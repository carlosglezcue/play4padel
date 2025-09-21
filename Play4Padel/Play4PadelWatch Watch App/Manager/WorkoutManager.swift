//
//  WorkoutManager.swift
//  Play4Padel
//
//  Created by Carlos Gonzalez on 8/2/25.
//

import SwiftUI
import HealthKit

class WorkoutManager: NSObject, ObservableObject, HKWorkoutSessionDelegate {
    let healthStore = HKHealthStore()
    
    @Published private(set) var authorizationStatus: Bool = false
    @Published var activeCalories: Double = 0.0
    @Published var heartRate: Double = 0.0
    
    var startTime: Date?
    var endTime: Date?
    var workoutSession: HKWorkoutSession?
    private var typesToRead: Set<HKObjectType> {
        Set([
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.workoutType()
        ])
    }
    
    private var typesToShare: Set<HKSampleType> {
        Set([
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.workoutType()
        ])
    }
    
    @MainActor
    func requestAuthorization() async throws -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthKitError.notAvailable
        }
        
        do {
            try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
            return true
        } catch {
            throw HealthKitError.authorizationFailed(error)
        }
    }
    
    func startWorkout() {
        startTime = Date()
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        
        do {
            let session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            session.delegate = self
            self.workoutSession = session
            session.startActivity(with: startTime)
        } catch {
            print("Error to start workout session: \(error.localizedDescription)")
        }
    }
    
    func resumeWorkout() {
        guard let session = workoutSession else { return }
        session.resume()
    }
    
    func pauseWorkout() {
        guard let session = workoutSession else { return }
        session.pause()
    }
    
    func endWorkout() {
        guard let session = workoutSession else { return }
        session.end()
    }
    
    func setEndTime() {
        endTime = Date()
    }
    
    func calculateWorkoutDuration() -> TimeInterval? {
        guard let start = startTime, let end = endTime else { return nil }
        return end.timeIntervalSince(start)
    }
    
    func saveToHealthKit(calories: Double, heartRate: Double) {
        guard let duration = calculateWorkoutDuration(),
              let start = startTime,
              let end = endTime else { return }
        
        let calorieType = HKQuantityType(.activeEnergyBurned)
        let calorieQuantity = HKQuantity(unit: .kilocalorie(), doubleValue: calories)
        let calorieSample = HKQuantitySample(type: calorieType, quantity: calorieQuantity, start: start, end: end)
        
        let heartRateType = HKQuantityType(.heartRate)
        let heartRateQuantity = HKQuantity(unit: HKUnit.count().unitDivided(by: HKUnit.minute()), doubleValue: heartRate)
        let heartRateSample = HKQuantitySample(type: heartRateType, quantity: heartRateQuantity, start: start, end: end)
        
        let durationQuantity = HKQuantity(unit: HKUnit.minute(), doubleValue: duration / 60.0)
        
        let workoutDurationSample = HKQuantitySample(
            type: HKQuantityType(.appleExerciseTime),
            quantity: durationQuantity,
            start: start,
            end: end
        )
        
        healthStore.save([calorieSample, heartRateSample, workoutDurationSample]) { success, error in
            if let error = error {
                print("Error to save in HealthKit: \(error)")
            } else {
                print("Data saved in HealthKit correctly.")
            }
        }
    }
    
    func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState,
        date: Date
    ) {
        switch toState {
            case .running:
                self.workoutSession = workoutSession
                print("Workout session started")
            case .paused:
                print("Workout session in pause")
            case .ended:
                print("Workout session finished")
                self.workoutSession = nil
            default:
                break
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Error in workout session: \(error.localizedDescription)")
    }
    
    func fetchActiveCalories() async -> Double {
        guard let start = startTime, let end = endTime else { return 0.0 }
        let calorieType = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: calorieType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                let totalCalories = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0.0
                continuation.resume(returning: totalCalories)
            }
            healthStore.execute(query)
        }
    }
    
    func fetchHeartRate() async -> Double {
        guard let start = startTime, let end = endTime else { return 0.0 }
        let heartRateType = HKQuantityType(.heartRate)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: heartRateType,
                quantitySamplePredicate: predicate,
                options: .discreteAverage
            ) { _, result, _ in
                let avgHeartRate = result?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0.0
                continuation.resume(returning: avgHeartRate)
            }
            healthStore.execute(query)
        }
    }
    
    func fetchTotalDistance() async -> Double {
        guard let start = startTime, let end = endTime else { return 0.0 }
        let distanceType = HKQuantityType(.distanceWalkingRunning)
        let predicate = HKQuery.predicateForSamples(
            withStart: start,
            end: end,
            options: .strictStartDate
        )
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: distanceType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                let totalDistance = result?.sumQuantity()?.doubleValue(for: .meter()) ?? 0.0
                continuation.resume(returning: totalDistance)
            }
            healthStore.execute(query)
        }
    }
}

enum HealthKitError: Error {
    case notAvailable
    case authorizationFailed(Error)
    
    var localizedDescription: String {
        switch self {
            case .notAvailable:
                return "HealthKit is not available on this device"
            case .authorizationFailed(let error):
                return "Error to request authorization: \(error.localizedDescription)"
        }
    }
}

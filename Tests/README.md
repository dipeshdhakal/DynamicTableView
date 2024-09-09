
  

# stability-tracker-ios

A tracking library for iOS development at Expedia Group. It provides capabilities for tracking various types of logs.

  

## Installation

Using SPM:

```swift

dependencies: [.package(url: "https://github.expedia.biz/eg-ios/stability-tracker-ios.git", .upToNextMinor(from: "2.0.1"))]
```

  

## Setup

Each methods are exposed via `StabilityTracker.shared` static variable.

Before sending any events, we need to setup the SDK by calling following method.

```swift

StabilityTracker.shared.setup(with: Configuration(), contextInfoProvider: MyContextInfoProvider())
```

  

## Tracking tasks

### Single task

Track a single independent task is completed (success or failure).

  

#### By sending a payload:

`StabilityTracker.shared.track(tracker: UserTaskTracker)`

  

#### By sending parameters:

`StabilityTracker.trackSuccess(eventName: String, status: EventStatus, featureArea: String, duration: Int? = nil, failureCategory: UserTaskTracker.FailureCategory? = nil, parameters: [String: Encodable] = [:])`

  

### Multiple tasks

When a success of a single task is determined by success of all subtasks, use `MultiTaskTracker`.

  

Initialise `MultiTaskTracker` as follows.

```swift

let multitaskTracker = StabilityTracker.shared.initMultiTaskTracker(eventName: String, featureArea: String, subTasks: [String]) -> MultiTaskTracker

```

Then every time a subtask is complete, call

```swift

multitaskTracker.complete(subTask: String, with status: Status)

```

example:

  
```swift
multiTaskTracker.complete(subTask: "task1", with .success)

multiTaskTracker.complete(subTask: "task2", with .failure)
```

  

SDK logs task success or failure after all subtasks report their status. If ANY of the subtask has failed, then task reports failure or success.

  

Note: SDK only sends payload once per init. To reuse, remember to call `multiTaskTracker.restart()` if task needs to be restarted.

  

  

## Logging message

### By sending payload

```swift

StabilityTracker.shared.track(tracker: LogTracker)

```

### By sending parameters

```swift

StabilityTracker.shared.logMessage(message: String, level: LogLevel, parameters: [String: Encodable] = [:])

```

Note: backend only supports logging `LogLevel.error` for now.

  

  

## Logging network payload

Call the following method for tracking network logs.

```swift

StabilityTracker.shared.track(tracker: NetworkTracker)

```

  

## Additional Data

Along with the payload and context info passed from client app, SDK also adds following device information internally from SDK in all logs:

  
```swift
"platform": "iOS"

"device_os_version": UIDevice.current.systemVersion

"device_brand": "Apple"

"device_model": <model_of_the_device> // eg iPhone 13

"network_connected": <if_network_is_connected>

"network_type": <type_of_network> // eg: Cellular
```

  

## Workflow in SDK

SDK is setup, SDK looks for older cached files more than (Configuration.Cache.ttl = 86400) seconds, and deletes older files

1. Event is received from client app and collected

2. Events are delayed (throttled) upto (Configuration.EventCollection.delaySeconds = 1) seconds or (Configuration.EventCollection.count = 10 sec) max items

3. Network call is made to send events (combined in one API if nore than 1 event before delaySeconds)

4. If failed network calls, retried upto (Configuration.NetworkRequest.retryCount = 2) times

5. If still failed, events are saved in local cache in files

  

SDK scans for cache files every (Configuration.Cache.evaluationIntervalSeconds=30) seconds

1. If cache exist and is older than (Configuration.Cache.ttl = 86400) seconds delete them, otherwise retry cached events to send to API

2. Delete cached event files

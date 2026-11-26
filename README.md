# JobsKit

A Swift package for finding and reading jobs at Apple.

> JobsKit is not made by or connected to Apple. It uses the same web service as Apple's jobs site. Apple doesn't document that service and could change it at any time.
>
> Apple's [Website Terms of Use](https://www.apple.com/legal/internet-services/terms/site.html) may not allow automated access to its sites. You're responsible for making sure your use of JobsKit follows them. Keep requests light, and don't republish job listings.

## Requirements

- Swift 6.4
- macOS 12, iOS 15, watchOS 9, tvOS 15, visionOS 1, or Linux

## Install

In Xcode, choose **File → Add Package Dependencies**, and enter:

```
https://github.com/mohalibou/JobsKit
```

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/mohalibou/JobsKit.git", from: "0.1.0"),
],
```

Then add `"JobsKit"` to your target's dependencies.

JobsKit is still before version 1.0, so a new minor version, such as 0.2.0, may change its API. You'll only get those when you choose to update.

## Search for jobs

```swift
import JobsKit

let client = JobsClient()

let page = try await client.jobs(matching: JobQuery(text: "swift"))

for job in page.jobs {
    print(job.title)
}
```

Each page has up to 20 jobs. To get another page, pass its number:

```swift
let secondPage = try await client.jobs(matching: JobQuery(text: "swift"), page: 2)
```

To go through every job, use `allJobs`. It loads pages as you need them.

```swift
for try await job in client.allJobs(matching: JobQuery(text: "swift")) {
    print(job.title)
}
```

## Filter jobs

```swift
let query = JobQuery(
    text: "swift",
    teams: [.all(in: .softwareAndServices)],
    products: [.siri],
    workplace: .remoteOnly,
    sort: .newest
)
```

You can also pick a smaller team:

```swift
let query = JobQuery(teams: [TeamFilter.SoftwareAndServices.appsAndFrameworks])
```

To filter by place, find the place first:

```swift
let places = try await client.locations(matching: "Cupertino")
let query = JobQuery(locations: places.map(\.id))
```

## Read a job

```swift
let details = try await client.details(for: job.id)

print(details.title)
print(details.description ?? "No description")
```

Some jobs list their pay:

```swift
for place in details.locationDetails {
    if let pay = place.payRange {
        print(pay.minimum, pay.maximum, pay.period)
    }
}
```

Pay is read from the job's text, so it may be missing. It only works with English text and doesn't include the currency.

## Other things you can get

| What | How |
|---|---|
| Job title suggestions | `client.titleSuggestions(for: "swift")` |
| Places | `client.locations(matching: "London")` |
| The area around a place | `client.areas(around: [place.id])` |
| Teams | `client.teams()` |
| Products | `client.products()` |
| Languages | `client.languages(matching: "French")` |
| Stores for a job | `client.stores(for: job.id, nearZIPCode: "95014")` |
| Pay and benefits | `client.payAndBenefits(for: job.id, at: place.id)` |

## Change the language

```swift
let client = JobsClient(locale: .deDE)
```

Some text, such as job postings, may still be in English.

## Handle errors

```swift
do {
    let details = try await client.details(for: job.id)
    print(details.title)
} catch JobsError.notFound {
    print("This job is gone.")
} catch {
    print(error.localizedDescription)
}
```

## If a name is "ambiguous"

`SortOrder` is also a name in Foundation, and `Product` is also a name in StoreKit. If Xcode says one is ambiguous, add one of these to your file:

```swift
import enum JobsKit.SortOrder
import struct JobsKit.Product
```

## License

JobsKit uses the [MIT license](LICENSE).

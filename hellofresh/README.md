HelloFresh Backend Developer GoLang Test
====================

Hello and thanks for taking the time to try this out.

The goal of this test is to assert (to some degree) your coding and architectural skills. You're given a simple problem so you can focus on showcasing development techniques.

This test should be written in Go language.

You're **encouraged** to use GoLang Standard library and **allowed** to use third party libraries, as long as you put them together yourself **without relying on a framework or microframework** to do it for you. An effective developer knows what to build and what to reuse, but also how his/her tools work. Be prepared to answer some questions about those libraries, like why you chose them and what other alternatives you're familiar with.

As this is a code review process, please avoid adding generated code to the project. This makes our jobs as reviewers more difficult, as we can't review code you didn't write. This means avoiding committing vendor folders or similar, which generates thousands of lines of code in stub files.

_Note: While we love open source here at HelloFresh, please do not create a public repo with your test in! This challenge is only shared with people interviewing, and for obvious reasons, we'd like it to remain this way._

Instructions
-----

1. Clone this repository.
2. Create a new branch called `dev`.
3. Create a pull request from your `dev` branch to the master branch. This PR should contain setup instructions for your application and a breakdown of the technologies & packages you chose to use, why you chose to use them, and the design decisions you made.
4. Reply to the thread you're having with our HR department telling them we can start reviewing your code

Given
-----

You are given an external API endpoint which allows to query recipe information. Each recipe can be accessed by an `integer` id.
The recipe id enumeration starts from `1`.

Example HTTP calls

```
curl -X GET https://s3-eu-west-1.amazonaws.com/test-golang-recipes/1
curl -X GET https://s3-eu-west-1.amazonaws.com/test-golang-recipes/2
curl -X GET https://s3-eu-west-1.amazonaws.com/test-golang-recipes/5
```

Task
----

Design an application which would act as a reverse proxy and expose the _aggregated recipes_ from the external API over HTTP.

#### Requirements

- The recipes in the aggregated list **must** contain the same data as the original recipes. Data modifications are **not allowed**.
- The endpoint response **must** be `JSON` encoded.
- The endpoint response time **must** be lower than `1s`.
- The application should be stateless, i.e. it is **not allowed** to cache the recipe response on the application side.
- The endpoint **should not** render all the recipes in a single response. It is **allowed** to make [use of pagination](http://docs.oasis-open.org/odata/odata/v4.01/cs01/part2-url-conventions/odata-v4.01-cs01-part2-url-conventions.html#_Toc505773300).

##### Use Case #1 - all recipes

A user should be able to retrieve an aggregated list of **all the recipes** from the source API.

_Specific requirements_
- The endpoint **must** provide access to ALL available recipes.
- The order for the rendered recipes **is irrelevant**
- The solution should operate under the assumption that the source API contains an unlimited number of recipes.

> `All available recipes` are the recipes with the `id` lower than the `id` with the first `404 Not Found` HTTP response status code.
>
> For example, if
>  `curl -X GET https://s3-eu-west-1.amazonaws.com/test-golang-recipes/99999` returns HTTP status code `200 OK`
> and
> `curl -X GET https://s3-eu-west-1.amazonaws.com/test-golang-recipes/100000` returns HTTP status code `404 Not Found`
> then
> `all available recipes` are the ones with the `ids` from 1 to 99999



Example endoint: `GET http://myservice.io/recipes`

```json
[
    {
        "id": "5",
        // ...
    },
    {
        "id": "1",
        // ...
    },
    {
        "id": "2",
        // ...
    }
]
```

##### Use Case #2 - recipes by `id`

A user should be able to retrieve a list of **aggregated recipes** from the source API by a given `id`.

_Specific requirements_

- The endpoint **must** provide access to the recipes by the provided `id`.
- The recipes should be ordered by `prepTime` from lowest to highest.

Example endpoint and response: `GET http://myservice.io/recipes?ids=1,2,5`

```json
[
    {
        "id": "1",
        "prepTime": "PT30",
        // ...
    },
    {
        "id": "5",
        "prepTime": "PT30",
        // ...
    },
    {
        "id": "2",
        "prepTime": "PT35",
        // ...
    }
]
```

Evaluation Criteria
--------------

1. The problems are solved efficiently and effectively, the application works as expected.
2. The application is supplied with the setup scripts. Consider using docker and a one-liner setup.
3. You demonstrate the knowledge on how to test the critical parts of the application. We **do not require** 100% coverage.
4. The application is well and logically organised.
5. The submission is accompanied by documentation with the reasoning on the decisions taken.
6. The code is documented and is easy to follow.
7. The answers you provide during code review.
8. An informative, detailed description in the PR.
9. Following the industry standard style guide.
10. A git history (even if brief) with clear, concise commit messages.

---

Good luck!

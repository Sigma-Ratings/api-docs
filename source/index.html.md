---
title: Sigma API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

toc_footers:
  - <a href='https://terminal.sigmaratings.com'>Sign Up for a Developer Key</a>

includes:
  - errors

search: true

code_clipboard: true
---

# Introduction

Welcome to the Sigma Ratings API! You can use our API to access entities API endpoints.

We have language bindings in Shell! You can view code examples in the dark area to the right.

# Overview

## Risk Scoring

Sigma's Risk Scoring API is Sigma's first API and brings together over 60 proprietary risk indicators (flags) to derive scores and provide access to key risk related data on 300 million companies worldwide.

# Authentication

The Sigma API uses Basic Authentication to access the API. 

You can register a new API key in the authorization section of our [application](https://terminal.com/).

## Basic Authentication

To authorize your request you need to pass in an Authorization header. The following is an example of an Authorization Header:

`Authorization: Basic ZGVtbzpwQDU1dzByZA==`

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
curl "https://api.sigmaratings.com/v1/search/company""
  -H "Authorization: Basic ZGVtbzpwQDU1dzByZA==""
```


<aside class="notice">
You must replace <code>"ZGVtbzpwQDU1dzByZA=="</code> with your personal API key.
</aside>

# Available Endpoints

## Risk Scoring

```shell
curl "http://example.com/v1/risk/<ID>"
  -H "Authorization: mZGVtbzpwQDU1dzByZA=="
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 1,
    "name": "Fluffums",
    "breed": "calico",
    "fluffiness": 6,
    "cuteness": 7
  },
  {
    "id": 2,
    "name": "Max",
    "breed": "unknown",
    "fluffiness": 5,
    "cuteness": 10
  }
]
```

This endpoint retrieves a country risk.

### HTTP Request

`GET https://api.sigmaratings.com/v1/risk/<ID>`

### URL Parameters

Parameter |  Description
--------- |  -----------
ID | Specified entity ID

<aside class="success">
All requests must specify an Authorization header.
</aside>


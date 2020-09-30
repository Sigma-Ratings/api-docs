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

To obtain an API key please contact our client support team.

## Basic Authentication

To authorize your request you need to specify a base64 encoded value of the provided Sigma API key in an Authorization header. See [RFC2617](https://tools.ietf.org/html/rfc2617) for Basic Authentication reference. The following is an example of an encoded Authorization Header:

`Authorization: Basic ZGVtbzpwQDU1dzByZA==`

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
curl "https://api.sigmaratings.com/v1/account_status"
  -H "Authorization: Basic ZGVtbzpwQDU1dzByZA==""
```


<aside class="notice">
You must replace <code>"ZGVtbzpwQDU1dzByZA=="</code> with your personal API key.
</aside>

# Available Endpoints

## API Account Status

```shell
curl "https://api.sigmaratings.com/v1/account_status"
  -H "Authorization: mZGVtbzpwQDU1dzByZA=="
```

> The above command returns JSON structured like this:

```json
{
  "msg": "ok",
  "token": "<API Key>",
  "request_limit": 10,
  "refresh_period": "monthly",
  "created": "2020-09-29T15:59:50.085109Z",
  "expires": null,
  "active": true,
  "permissions": {},
  "currentRequests": 0
}
```

This endpoint retrieves information about your API key.

### HTTP Request

`GET https://api.sigmaratings.com/v1/acccount_status`

## Risk Scoring

```shell
curl "https://api.sigmaratings.com/v1/risk?q=<entity name>"
  -H "Authorization: mZGVtbzpwQDU1dzByZA=="
```

> The above command returns JSON structured like this:

```json
{
   "score": {
        "rank": 1,
        "level": "Severe"
   },
   "indicator_count": [{}
   ],
   "results": [
    {
      "name": "",
      "type": "",
      "strength": "",
      "description": "",
      "source": "",
      "indicators": [
        {
          "name":"",
          "source_url":"",
          "outlook": -2,
          "stability": 1,
          "description": "",
          "score": 50
        }
      ],
      "locations": [
        {
          "country":"",
          "code": "",
          "type": "",
          "sources": "",
          "addresses": [{}],
          "risk": ""
        }
      ]
    }
   ]
}
```

This endpoint retrieves a country risk.

### HTTP Request

`POST https://api.sigmaratings.com/v1/risk`

### URL Parameters

Parameter |  Description
--------- |  -----------
q | Entity search value

### Request body

Parameter | Description | Type   |
--------- | ----------- | ---------- |
filters | Filters to apply to search | Object |



<aside class="success">
All requests must specify an Authorization header.
</aside>


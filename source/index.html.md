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

<aside class="notice">
When using <code>curl</code> on Microsoft Windows you need to replace single-quotes in the examples with double-quotes. Alternatively, you can replace with <code>\"</code>.
</aside>

# Available Endpoints

<aside class="success">
All requests must specify an Authorization header.
</aside>

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

Sigma's Risk Scoring API is Sigma's first API and brings together over 50 proprietary risk indicators (flags) to derive scores and provide access to key risk related data on 300 million companies worldwide. You can use the Risk Scoring end point to prioritize investigations and diligence by accessing a summary and score for any entity name.


```shell
curl "https://api.sigmaratings.com/v1/risk?q=<entity name>"
  -H "Authorization: mZGVtbzpwQDU1dzByZA==" -d '{"filters":{"threshold":0.98, "category":"sigma"}}'
```

> The above command returns JSON structured like this:

```json
{
	"score": {
		"rank": 73,
		"level": "Severe"
	},
	"indicator_summary": {
		"Address Risk": 1
	},
	"results": [{
		"name": "YARDPOINT SALES LLP",
		"type": "company",
		"strength": 0.9433497536945812,
		"source": "Corporate Registries",
		"indicators": [{
			"name": "Address Risk",
			"source_url": "",
			"description": "YARDPOINT SALES LLP is located at 175 Darkes Lane Suite B, 2nd Floor, Potters Bar, Hertfordshire, EN6 1BW which appears to be associated with Alleged Shell Companies",
			"score": 70
		}],
		"locations": [{
			"country": "United Kingdom",
			"country_code": "GB",
			"type": "headquarters",
			"sources": [
				"https://opencorporates.com/companies/gb/OC374526"
			],
			"addresses": [{
				"address": "175 Darkes Lane Suite B, 2nd Floor, Potters Bar, Hertfordshire, EN6 1BW"
			}]
		}]

	}]
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

_**filters**_ can be:

Filter | Description | Type | 
-------| ----------- | ----- | 
threshold | A decimal representation of match strength | float | 
addresses | Filters addresses from search results | Array |
category | Sigma category | string |



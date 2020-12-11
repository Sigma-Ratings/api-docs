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

`POST https://api.sigmaratings.com/v1/bulk`

### URL Parameters

Parameter |  Description | Type | Default Value
--------- |  ----------- | ------- | ----------
threshold | A decimal representation of match strength | float | 0.95
category | <name of category here> | string | <insert default value here>

### Request body


## API Bulk

```shell
cat entities
{"id":"1", "YARDPOINT SALES LLP"}
{"id":"2", "Sigma Ratings"}
curl "https://api.sigmaratings.com/v1/bulk"
  -H "Authorization: mZGVtbzpwQDU1dzByZA==" -H "Content-Type: application/x-ndjson"
  -XPOST --data-binary "@entities"
```

> The above command returns JSON structured like this:

```json
{
  "id": "1e67becc-9405-4a3c-b4d0-78144bc8bba4",
  "message": "Request submitted",
  "created_at": "2016-11-28T00:00:00.0000000Z"
}
```

This endpoint creates a bulk request.

<aside class="notice">
This endpoint requires the Content-Type to be set to application/x-ndjson. The Content-Type requires a new line
to separate each entry, JSON entries must not include `\n`'s as delimiters. <a href='http://ndjson.org'>ndjson specification reference</a>
</aside>

## API Bulk status

```shell
curl "https://api.sigmaratings.com/v1/bulk/:id"
  -H "Authorization: mZGVtbzpwQDU1dzByZA=="
```

> The above command returns JSON structured like this:

```json
{
  "id": "c9ebf761-8851-4550-be7e-a14d07e0e57a",
  "status": "Completed",
  "presigned_url": "https://sigmaratings-uploads.s3.amazonaws.com/c9ebf761-8851-4550-be7e-a14d07e0e57a/c9ebf761-8851-4550-be7e-a14d07e0e57a.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAQ7CCVENTOOV7CZ7M%2F20201210%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201210T213944Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=d1f8b6b2424be13692cff876775c27c25f698970fd4735ad7a1a2451593db23f",
  "created_at": "2016-11-28T00:00:00.0000000Z",
  "completed_at": "2016-11-29T00:00:00.0000000Z",
  "batches": {
    "total_num": 1,
    "total_num_completed": 1,
    "total_num_processing": 0,
    "total_num_remaining": 0
  }
}
```

This endpoint retrieves information about your API key.

### Response details

Field |  Description 
--------- |  -----------
id | An UUID to reference the request 
status | Status of request 
presigned_url | url to download request submitted. This field is only present when the request is completed. 
created_at | Date when request was created
completed_at | Date when request was completed
batches | Status of request indicating processing status




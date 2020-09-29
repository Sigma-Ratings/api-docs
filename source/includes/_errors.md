# Errors

<aside class="notice">
The following section describes the list of potential errors returned by Sigma Ratings API. 
</aside>

Error Code | Description
---------- | -------
400 | Bad Request --  Invalid request. 
401 | Unauthorized -- The specified API key is incorrect.
403 | Forbidden -- The specified API key is not authorized to use the endpoint.
404 | Not Found -- The specified endpoint is not valid.
405 | Method Not Allowed --  The specified HTTP Method is not allowed for the endpoint.
429 | Too Many Requests -- The request exceed the limit of requests allowed.
500 | Internal Server Error -- We had a problem with our server. Try again later.
503 | Service Unavailable -- We're temporarily offline for maintenance. Please try again later.

[![CircleCI](https://circleci.com/gh/miry/samples/tree/distribusion.svg?style=svg)](https://circleci.com/gh/miry/samples/tree/distribusion)

Implement library to parse data from the service and upload in unified format.

## `GET /routes`

### Params

- `passphrase` - string.
- `source` - string. possible values: sentinels, sniffers, loopholes

### Response

Return a zip file

```
HTTP/1.1 200 OK
Content-Disposition: attachment; filename*=UTF-8''sentinels
Content-Length: 996
Content-Type: application/zip
....
```

## `POST /routes`

Except only query params

### Params

- `passphrase` - string.
- `source` - string. possible values: sentinels, sniffers, loopholes
- `start_node` - alphanumeric code. values: alpha, beta, gamma, delta, theta, lambda, tau, psi, omega
- `end_node` - alphanumeric code. values: alpha, beta, gamma, delta, theta, lambda, tau, psi, omega
- `start_time` - ISO 8601 UTC time. YYYY-MM-DDThh:mm:ss
- `end_time` - ISO 8601 UTC time. YYYY-MM-DDThh:mm:ss

### Response

- 201 - very lucky to create
- 401 - if missing passphrase
- 503 - some field is not correct

USAGE
=====

To run localy application.

```
$ bin/local
```

Check logs in the `log/distribusion.log` and `STDOUT`.

TEST
====

```shell
$ rake test
```

TODO
====

- [x] Setup ruby application structure
- [x] Setup logger
- [ ] Load Sentinel records
- [ ] Parse Sentinel records
- [ ] Load Sniffers records
- [ ] Parse Sentinel records
- [ ] Load Loopholes records
- [ ] Parse Loopholes records
- [ ] Upload Sentinel records
- [ ] Upload Sniffers records
- [ ] Upload Loopholes records


Activities
==========

11 Aug 13:00:  Started

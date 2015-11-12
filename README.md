# puppet-nodequery

## Overview

This module installs the Nodequery Agent as described [here](https://nodequery.com/help/manual-installation).

## Parameters

There is only one parameter and it is the access token for the server.

```puppet
class { 'nodequery':
  token  => "TOKENHERE",
}
```
# Terraform Buildpack

![CI](https://github.com/jkutner/terraform-buildpack/workflows/CI/badge.svg?branch=main&event=push) ![Version](https://img.shields.io/badge/dynamic/json?url=https://cnb-registry-api.herokuapp.com/api/v1/buildpacks/jkutner/terraform&label=Version&query=$.latest.version)


This is a [Cloud Native Buildpack](https://buildpacks.io) for [Terraform](https://www.terraform.io/).

## Usage

Build an image from any repo containing `.tf` files:

```
$ pack build -b jkutner/terraform myapp
```

Then run your Terraform commands, like `apply`:

```
$ docker run -it myapp terraform apply
```

You can load secrets by passing them on the command-line, or loading them into a volume mounted under `/workspace`.

## Why use this instead of the official `Dockerfile`?

1. You don't need to copy and paste this buildpack into every repo where you need Terraform
1. You can configure your Terraform version, while using the same buildpack across many repos
1. You can centralize any logic like validating the Terraform SHA256
1. You can compose this buildpack with other buildpacks

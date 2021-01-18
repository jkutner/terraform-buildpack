# Terraform Buildpack

This is a [Cloud Native Buildpack](https://buildpacks.io) for [Terraform](https://www.terraform.io/).

## Usage

Build an image from any repo containing `.tf` files:

```
$ pack build -b jkutner/terraform myapp
```

Then run your Terrform commands, like `apply`:

```
$ docker run -it myapp terraform apply
```

You can load secrets by passing them on the command-line, or loading them into a volume mounted under `/workspace`.

## Why use this instead of the official `Dockerfile`?

1. You don't need to copy and paste this buildpack into every repo where you need Terraform
1. You can select your Terraform version, and use the same buildpack
1. You can centralize any logic like validating the Terraform SHA256
1. You can compose this buildpack with other buildpacks

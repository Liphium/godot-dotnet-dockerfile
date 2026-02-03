# Unofficial Godot .NET Docker Image

<center><img src="icons/godot_docker.png" alt="Godot Docker Image Logo" height="200"/></center>

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Godot](https://img.shields.io/badge/godot-%23478CBF.svg?style=for-the-badge&logo=godot-engine&logoColor=white)

This docker image is designed to build, test and export your games on a CI/CD pipeline. It
only contains the Godot engine with the tagged version.

If you're looking for a Docker image that doesn't include the .NET version of Godot, you might want to check out [this repository](https://github.com/graugraugrau/godot-dockerfile).

## Changes made by me (to the original repository)

- Make the Dockerfile download Godot Mono and be based on an official .NET image
- Download Mono build templates instead of normal ones
- Change the Forgejo Runner to a GitHub Actions workflow
- Only build versions of Godot .NET >= 4.4 (to decrease the amount of pipelines)
- Change the README to include this section and new instructions for the .NET version of the image

## Links

- [Godot Engine](https://godotengine.org/)
- [Docker Hub](https://hub.docker.com/r/liphium/godot-mono)
- [Github (Mirror)](https://github.com/liphium/godot-dotnet-dockerfile/)

## How to use

To test the image locally you can run:

```bash
docker container run liphium/godot-mono:4.4 godot --version
```

The following minimal examples demonstrate how to setup a basic pipeline for different automation servers. The example imports all assets, export a windows build and archives the result.

The example assumes, that the Godot project file is on the root folder of your repository.

> ![WARNING]
> Only the GitLab version of this has been tested since I forked this repository. Please open an issue in case there is any problem with the pipeline configurations below.

### Github

Add `.github/workflows/godot-ci.yml` to your repository with the following content:

```yml
name: Godot CI/CD

on:
  push:
    branches:
      - main

env:
  EXPORT_NAME: MyGodotGame

jobs:
  export_windows:
    runs-on: ubuntu-latest
    container: liphium/godot-mono:4.4
    steps:
      - name: Create symbolic link for export templates
        run: ln -s /root/.local /github/home/.local
      - name: Check out repository
        uses: actions/checkout@v4
      - name: Import Godot project
        run: godot --headless --import
      - name: Create build folder
        run: mkdir -p build/windows
      - name: Export Windows executable
        run: godot --headless --export-release Windows\ Desktop build/windows/${EXPORT_NAME}.exe
      - name: Archive Windows executable
        uses: actions/upload-artifact@v4
        with:
          name: ${{ env.EXPORT_NAME }}
          path: build/windows
          if-no-files-found: error
```

### Gitlab

Add `.gitlab-ci.yml` to your repository with the following content:

```yml
image: liphium/godot-mono:4.4

stages:
  - export

variables:
  EXPORT_NAME: MyGodotGame

export:
  stage: export
  only:
    - main
  script:
    - godot --headless --import
    - mkdir -p build/windows
    - godot --headless --export-release Windows\ Desktop build/windows/${EXPORT_NAME}.exe
  artifacts:
    name: $EXPORT_NAME
    paths:
      - build/windows
```

## Q&A

### Can I use this for linting?

The normal `dotnet` CLI is also available in the base image. You could create a pipeline that runs the following command for example:

```sh
dotnet format "<YOUR_SOLUTION_FILE>.sln" --verify-no-changes --verbosity diagnostic
```

### How would I run a scene for testing purposes?

While of course the real editor is not supported, you can still run scenes just like you would in your editor, just without the rendering. This can be useful for testing purposes. Here's how you would do that:

```sh
# Import the project
godot --headless --import

# Build the C# project (required for C# scripts to be executable)
godot --headless --build-solutions --quit
 
# Run the scene
godot --headless -d Test.tscn --quit
```

### How can I run the editor?

The docker image is no replacement for the editor. In the docker container godot should always be executed with the argument `--headless`.

# Check vulnerable NuGet packages GitHub Action

This action will check for vulnerable NuGet packages in the entire repository. If vulnerable packages are found, they will be listed and the build will fail.

The code is based on [this excellent blog post by Steven Giesel](https://steven-giesel.com/blogPost/a825c041-26dc-4488-8707-17697871d08e). Development of the action is sponsored by [elmah.io](https://elmah.io).

## Example usage

```yml
- name: Check vulnerable NuGet packages
  uses: elmahio/github-check-vulnerable-nuget-packages-action@v1            
```

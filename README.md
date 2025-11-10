# kearisp/npm-setup-deps-action


```yaml
steps:
  - name: Setup setup package version
    uses: kearisp/npm-setup-deps-action@v0.0.2
    with:
        package: "@kearisp/cli"
        tag: "beta"
```

#### Example of changes:

- **Before** changing `package.json` content:
  ```json
  {
      "dependencies": {
          "@kearisp/cli": "^3.0.0"
      }
  }
  ```
- **After** action process:
  ```json
  {
     "dependencies": {
         "@kearisp/cli": "^3.0.0-beta.0"
     }
  }
  ```


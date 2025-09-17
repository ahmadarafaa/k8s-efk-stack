# Contributing

Hey there! Thanks for wanting to help make this project better. Whether you're fixing a bug, adding a feature, or just improving the docs, I really appreciate it.

## Getting Started

### Found a Problem?
- Use the bug report template when you open an issue
- Tell me what Kubernetes version you're using, which Fluentd image, and which config file
- Walk me through how to reproduce the problem
- Paste any error logs you're seeing

### Want to Add Something?
1. Fork this repo
2. Make a new branch: `git checkout -b my-cool-feature`
3. Make your changes
4. Test everything works
5. Update the docs if needed
6. Send me a pull request

### Before You Submit
Make sure these things work:
- [ ] Your YAML files don't have syntax errors
- [ ] The Fluentd DaemonSet actually starts up
- [ ] Logs flow to Elasticsearch like they should
- [ ] You updated the README if you added something new

### Style Guidelines
- Use 2 spaces for YAML indentation (not tabs)
- Name things like other Kubernetes resources in this repo
- Add comments when your config does something tricky
- Keep your configs focused on one thing

### Adding New Configs
If you're creating a new Fluentd configuration:
1. Test it with some dummy apps first
2. Make sure logs get parsed and sent to the right place
3. Write down what problem it solves and when to use it
4. Add it to that comparison table in the README

### Documentation
- Update the README when you add features
- Include example commands people can copy-paste
- If something goes wrong often, add it to the troubleshooting section
- Keep the table of contents up to date

## Testing Your Changes

### What You Need
- A Kubernetes cluster (1.16 or newer)
- kubectl set up and working
- An Elasticsearch instance to send logs to

### How to Test
1. Deploy some test apps:
   ```bash
   kubectl apply -f examples/
   ```

2. Try your config:
   ```bash
   kubectl apply -f fluentd-solution/configs/your-new-config.yaml
   kubectl apply -f fluentd-solution/configs/fluentd-daemonset.yaml
   ```

3. Check if it works:
   ```bash
   kubectl logs -l k8s-app=fluentd-logging -n logging
   ```

## Community Stuff
- Be nice to people
- Help newcomers when you can
- Give feedback that helps, not just criticism
- Follow the code of conduct

## Questions?
Just open an issue if you want to discuss something or need help.
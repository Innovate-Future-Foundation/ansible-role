# Role Name

This role includes all the OS software dependencies management, and everything else need to configure at the OS level, such as setting environment variables.

# Requirements

- For a ubuntu server, need to update the apt package list

# Role Variables

None


# Dependencies

- A live Ubuntu server instance with SSH access.
- The `apt` package manager must be available on the target system.

# Example Playbook

An example playbook "base-playbook.yml"
```yaml
    - name: Base Server Settings
      hosts: test
      become: yes
      roles:
        - role: base
```

# Execute Playbook

```shell
    ansible-playbook -i inventory base-playbook.yml
```
# How to test

1. Navigate to the `roles/base/tests` folder
    ```bash
    cd roles/base/tests
    ```
2. Run the test playbook:
```shell
    ansible-playbook -i inventory test.yml
```
# License

Apache 2.0

# Author Information

Mark
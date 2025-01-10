# Role Name

This role manages the installation, configuration, and version control of Java Development Kits (JDK) on a target Ubuntu server. It ensures the expected JDK version is installed, removes incorrect versions, and verifies the installation.

# Requirements

- Install a JDK on the remote host.
- The `java` commands should be accessible globally.

# Role Variables

The following variables can be customized:

- `jdk_version`: The expected JDK version to install (e.g., `openjdk-8`).
- `java_jdk_versions`: A dictionary containing details of available JDK versions. Example structure:
  ```yaml
  java_jdk_versions:
    openjdk-8:
      version: "1.8.0"
      package: "openjdk-8-jdk"
    openjdk-11:
      version: "11.0.0"
      package: "openjdk-11-jdk"
  ```

# Dependencies

- The `base` role should be applied first if any OS-level configurations are required.
- A live Ubuntu server instance with SSH access.
- The `apt` package manager must be available on the target system.

# Example Playbook
An example playbook `java-playbook.yml`:
```yaml
- name: Configure Java
  hosts: test
  become: yes
  vars:
    jdk_version: openjdk-8
    java_jdk_versions:
      openjdk-8:
        version: "1.8.0"
        package: "openjdk-8-jdk"
      openjdk-11:
        version: "11.0.0"
        package: "openjdk-11-jdk"
  roles:
    - role: java
```

# Execute Playbook

Run the playbook using the following command:
```bash
ansible-playbook -i inventory java-playbook.yml
```

# How to Test

1. Navigate to the `roles/java/tests` folder
    ```bash
    cd roles/java/tests
    ```
2. Run the test playbook:
    ```bash
    ansible-playbook -i inventory test.yml
    ```

# License

Apache 2.0

# Author Information

Mark
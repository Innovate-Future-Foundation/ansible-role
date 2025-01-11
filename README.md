Jenkins Server Setup
=========

This Ansible Role automates the setup and configuration of a Jenkins server on an Ubuntu machine. It installs and configures various components required for a fully operational CI/CD environment.

Requirements
------------

- Ansible 2.16 or higher installed on the control node.
- An Ubuntu server with `sudo` privileges.

> [!TIP]
> For local tests, you may use the `tests/docker-compose.yml` file to start a Ubuntu 24.04 container.

How to Use
------------
1. Clone this repository to your Ansible roles directory:
    ```bash
    git clone https://github.com/Innovate-Future-Foundation/ansible-role-jenkins.git ansible-role-jenkins
    ```

2. Create an `inventory` file:
    ```
    [test_ubuntu]
    localhost ansible_user=root ansible_port=23 ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
    ```
    For detailed inventory file configurations, see [Ansible doc](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#how-to-build-your-inventory).

3. Run the playbook:
    ```bash
    ansible-playbook -i inventory playbook.yml
    ```

File Structure
------------
```mermaid
graph LR
    A[ansbile-role-jenkins] --> B[roles]
    B --> B1[base]
    B --> B2[java]
    B --> B3[jenkins]
    B --> B4[...]
    A --> C[tests]
    A --> .ansible-lint.yml
    A --> ansible.cfg
```

Directories
------------
The following is a breakdown of the key files and directories in this role:

- **`roles/`**: Contains the flexibility roles for configuring Jenkins server.
- **`tests/`**: Integration tests for combined roles.
- **`.ansible-lint.yml`**: Contains `ansible-lint` configurations. Use below command to run lint
  ```shell
  ansible-lint -c .ansible-lint.yml
  ```
- **`ansible.cfg`**: Ansible Configuration Settings file, see [Ansible doc](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-configuration-settings). Configure environment variable using the below command or you can also configure in OS profile or user profile.
  ```shell
  export ANSIBLE_CONFIG=/path/to/your/ansible.cfg
  ```

Role Directories
------------
```mermaid
graph LR
    A[roles] --> B[defaults/]
    A --> C[files/]
    A --> D[handlers/]
    A --> E[meta/]
    A --> F[tasks/]
    F --> F1[main.yml]
    F --> F2[...]
    A --> G[templates/]
    A --> H[tests/]
    A --> I[vars/]
    A --> J[LICENSE]
    A --> K[README.md]
```
The following is a breakdown of the key files and directories in this role:

- **`defaults/`**: Contains default variables used in the role.
- **`files/`**: Includes static files required for configuration.
- **`handlers/`**: Contains handlers triggered by task notifications, such as restarting services.
- **`meta/`**: Defines metadata about the role, such as dependencies.
- **`templates/`**: Stores Jinja2 templates for dynamic file generation.
- **`tests/`**: Includes test playbooks for validating the role.
- **`vars/`**: Contains role-specific variables.

For each role, you can use the below command to create the file structure.
```shell
ansible-galaxy init [role_name]
```

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Tasks
--------------
The main functionality is divided into specific task files for modularity:
- **`install_certbot.yml`**: Installs Certbot and generates SSL certificates.
- **`install_docker.yml`**: Installs Docker and Docker CLI for containerized environments.
- **`install_dotnet.yml`**: Installs the .NET SDK and tools like `dotnet-ef`.
- **`install_jdk.yml`**: Installs OpenJDK required for Jenkins.
- **`install_jenkins_plugins.yml`**: Installs Jenkins plugins using the Plugin Installation Manager.
- **`install_nginx.yml`**: Installs and configures Nginx as a reverse proxy for Jenkins.
- **`install_nodeJs.yml`**: Installs Node.js for JavaScript-based tooling.
- **`setup_Ubuntu.yml`**: Prepares the Ubuntu environment by installing essential packages.
- **`settings.yml`**: Configures environment-specific settings.
- **`main.yml`**: The entry point for executing all tasks in this role.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

This role is licensed under the Apache 2.0 License. See the `LICENSE` file for details.

Author Information
------------------

Developed by [Mark](https://github.com/markma85). Contributions are welcome!

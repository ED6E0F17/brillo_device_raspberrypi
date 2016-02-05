SELinux in Brillo
=================

## What is SELinux?
SELinux is an implementation of a Mandatory Access Control (MAC) mechanism.
It provides fine-grained control over allowed process behavior by defining a
system-wide security policy.

The most important concept in SELinux is the concept of a domain.
A domain specifies what a process can do on the system; it can be understood as
a grouping of permissions.
The system-wide security policy is composed of all the domains defined in the
system, with their permissions.

## Why SElinux?
Brillo is based on Android, and tries to remain as close to a strict subset of
Android as possible.
Android [uses SELinux](https://source.android.com/security/selinux/) to enforce
its security policy, so Brillo does the same.

## Hacking with SELinux
By default, Brillo is configured in *enforcing* mode, which means that processes
must be specifically granted permissions.
The first thing a new process needs is a domain to run in.
Brillo provides a sample domain for user-written Brillo services in the
[`brillo_service.te`](https://android.googlesource.com/device/generic/brillo/+/master/sepolicy/brillo_service.te)
file:

```
type brillo_service, domain;
type brillo_service_exec, exec_type, file_type;

# To use 'brillo_service' as the domain for your service,
# label the service's executable as 'brillo_service_exec' in the 'file_contexts'
# file in this directory.
# brillo_domain() below ensures that executables labelled 'brillo_service_exec'
# will be put in the 'brillo_service' domain at runtime.

# Allow domain transition from init, and access to D-Bus and Binder.
# See 'te_macros' in this directory for details.
brillo_domain(brillo_service)
```

Files describing domains use the extension `.te`.
Domains are expressed as types in SELinux, so `.te` (type enforcement) files
describe what rules are enforced for that type (domain).

Every process in the system is labelled with a domain label.
Files on the system are also labelled with a single file type.
A process can be put in a specific domain using two mechanisms:

* By calling an SELinux function from the process.
* By labelling the process' executable file and defining an automatic
    transition rule between the label of the file on disk and the label of the
    process' runtime domain.

In `brillo_service.te`, the `brillo_domain` macro tells the system to always put
processes executed from files labelled as `brillo_service_exec` in the
`brillo_service` domain.

For this automatic transition to work, files have to be labelled correctly.
File labelling happens in the [`file_contexts`](https://android.googlesource.com/device/generic/brillo/+/master/sepolicy/file_contexts)
file:

```
...
/system/bin/firewalld      u:object_r:firewalld_exec:s0

/data/misc/apmanager(/.*)? u:object_r:apmanager_data_file:s0
/system/bin/apmanager      u:object_r:apmanager_exec:s0
...
```

If you're adding a new service, you need to add the service's executable to the
`file_contexts` file and then adding a matching `.te` file in the same
directory.
For most user-written services, the `brillo_service` domain should be a good
starting point.

## Configuring SELinux permissions

It's likely that your service will require access to resources not covered by
the `brillo_service` domain.
In that case, you will see error messages like this on your device's logs:

```
firewalld: type=1400 audit(0.0:9): avc: denied { search } for name="proc" dev="debugfs" ino=15882 scontext=u:r:firewalld:s0 tcontext=u:object_r:debugfs:s0 tclass=dir permissive=0
```

You can use the `audit2allow` command to translate these errors to
SELinux policy lines that can be added to the `.te` file:

```
$ audit2allow -i {file with error messages} -p ${ANDROID_PRODUCT_OUT}/root/sepolicy
```

## TBD
### Common recipes/access to common services
### Binder rules and macros
### Naming conventions
- `allow_call_{service}` for services exposed over binder.
- `use_{resource|service}` for other services or resources.

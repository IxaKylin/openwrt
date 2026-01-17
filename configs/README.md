# OpenWrt Defconfig Directory

This directory contains default configuration files for OpenWrt builds, similar to the Linux kernel's `arch/*/configs/` mechanism.

## Usage

### Load a defconfig

To load a defconfig from this directory:

```bash
make <config_name>_defconfig
```

For example:

```bash
# Load the MediaTek FilioC configuration
make mediatek_filogic_defconfig

# Load the standard configuration
make standard_defconfig
```

This will:
1. Copy the specified defconfig to `.config` in the root directory
2. Run the configuration system to ensure all symbols are set correctly
3. Create a usable `.config` file for building

### List available defconfigs

To see all available defconfigs:

```bash
make list_defconfigs
```

### Save current configuration as a defconfig

To save your current `.config` as a new defconfig:

```bash
make savedefconfig DEFCONFIG=<name>
```

For example:

```bash
make savedefconfig DEFCONFIG=my_custom_router
```

This will save the current `.config` to `configs/my_custom_router`.

**Note**: It's recommended to add a short description at the top of your defconfig file:

```
# My Custom Router Configuration
# Optimized for home router with VPN and NAS support
```

## File Naming Convention

Defconfig files should follow this naming pattern:

```
<target_name>_defconfig
```

Examples:
- `mediatek_filogic_defconfig` - MediaTek FilioC platform
- `x86_64_defconfig` - x86_64 platform
- `standard_defconfig` - Generic configuration
- `router_basic_defconfig` - Basic router setup

## File Format

Defconfig files use the standard OpenWrt/Kconfig format:

```makefile
CONFIG_MODULES=y
CONFIG_HAVE_DOT_CONFIG=y
CONFIG_TARGET_mediatek=y
CONFIG_TARGET_mediatek_filogic=y

# Packages
CONFIG_PACKAGE_base-files=y
CONFIG_PACKAGE_busybox=y
CONFIG_PACKAGE_netifd=y

# Options
CONFIG_TARGET_IMAGES_GZIP=y
```

## Example Workflow

```bash
# Start with a standard configuration
make standard_defconfig

# Customize the configuration
make menuconfig

# Save your custom configuration
make savedefconfig DEFCONFIG=my_production_build

# Later, load the same configuration
make my_production_build_defconfig

# Build OpenWrt
make -j$(nproc)
```

## Best Practices

1. **Keep defconfigs minimal**: Only include options that differ from defaults
2. **Add descriptive headers**: Document the purpose and target platform
3. **Use meaningful names**: Choose names that describe the configuration
4. **Test your defconfigs**: Ensure they produce buildable configurations
5. **Version control**: Track defconfigs in git for reproducible builds

## Existing Defconfigs

- `standard_defconfig` - Generic configuration for most platforms
- `mediatek_filogic_defconfig` - MediaTek FilioC (MT7981/MT7986) based boards

## Integration with CI/CD

These defconfigs can be used in automated build systems:

```yaml
# Example GitLab CI
build:
  script:
    - make mediatek_filogic_defconfig
    - make -j$(nproc)
  artifacts:
    paths:
      - bin/
```

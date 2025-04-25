


# SSH Setup

Setup SSH on nix-on-droid if not done already:
<https://github.com/nix-community/nix-on-droid/wiki/SSH-access>
Add your desktop's SSH public key to the nix-on-droid user's ~/.ssh/authorized_keys file.

# UID/GID Handling

The primary issue is ensuring the correct uid and gid for the nix-on-droid user on your phone. When building on your desktop, these might not match, leading to permission issues.

    Find the UID and GID on your Android device:

    id nix-on-droid

This command returns the uid and gid of the nix-on-droid user on your device.

Set the UID and GID explicitly in your nix-on-droid configuration:

`{ 
  user.uid = <uid>;
  user.gid = <gid>;
} # Replace <uid> and <gid> with the values from your device
`
# Set Up the deploy-rs Configuration

The activation comes from above in this thread itself. Here's a helper to make it a little less repetitive.

`let
  activatenixondroid =
    configuration:
    inputs.deploy-rs.lib.aarch64-linux.activate.custom
      configuration.activationpackage
      "${configuration.activationpackage}/activate";
in
`
Here's how to configure your deploy-rs for nix-on-droid:

`deploy.nodes = {
  "pioneer" = {
    hostname = "pioneer.nixus.net"; # Replace with your device's hostname or IP (I use `dnsmaq` for local DNS)
    profiles.system = {
      sshUser = "nix-on-droid";
      user = "nix-on-droid";
      magicRollback = true;
      sshOpts = [ "-p" "8022" ]; # Adjust port if necessary (Step 1 dependent)
      path = activateNixOnDroid self.nixOnDroidConfigurations.pioneer;
    };
  };
};
`
Note: The hostname pioneer.nixus.net is specific to my setup using dnsmasq for local DNS resolution. Adjust it according to your environment.





# Handle Multiple Devices

If deploying to multiple devices, define specific configurations for each, especially if they have different uid and gid values.

```
nixondroidconfigurations = {
  "pioneer" = nix-on-droid.lib.nixondroidconfiguration {
    pkgs = pkgsfor "aarch64-linux";
    modules = [
      ./nix/hosts/pioneer.nix
      # include other modules like home manager if needed
      { 
        user.uid = 10701;
        user.gid = 10701;
      } # replace with the uid and gid from your device
    ];
  };

  "voyager" = nix-on-droid.lib.nixondroidconfiguration {
    pkgs = pkgsfor "aarch64-linux";
    modules = [
      ./nix/hosts/voyager.nix
      { 
        user.uid = 10403;
        user.gid = 10403;
      } # replace with the uid and gid from your other device
    ];
  };
};
```




# Set Up Cachix for Substitutes

To satisfy dependencies like static-proot, ensure your Nix settings include the necessary substituters and trusted public keys. This is crucial because nix-on-droid relies on prebuilt cross-compiled binaries for proot-static, which are specified by hard-coded Nix store paths in the configuration.

Nix Settings:
```
{
  nix.settings = {
    substituters = [
      # "https://cache.nixos.org/"
      # "https://nix-community.cachix.org"
      "https://nix-on-droid.cachix.org" <----
    ];

    trusted-public-keys = [
      # "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-on-droid.cachix.org-1:56snoMJTXmE7wm+67YySRoTY64Zkivk9RT4QaKYgpkE=" # <---
    ];
  };
} # Pretty sure you only need what's pointed out, but I kept my full Cachix config in case I'm missing something else.

```
## Reason for the Cache:

The nix-on-droid configuration specifies the prootStatic binary using hardcoded Nix store paths that point to prebuilt cross-compiled binaries:

```
environment.files = {
  prootStatic =
    let
      crossCompiledPaths = {
        aarch64-linux = "/nix/store/7qd99m1w65x2vgqg453nd70y60sm3kay-proot-termux-static-aarch64-unknown-linux-android-unstable-2024-05-04";
        x86_64-linux = "/nix/store/pakj3svvw84rhkzdc6211yhc2cgvc21f-proot-termux-static-x86_64-unknown-linux-android-unstable-2024-05-04";
      };
    in
    "${crossCompiledPaths.${targetSystem}}";
};
```
(Reference: nix-on-droid/modules/environment/login/default.nix#L90)

These binaries are not built locally during deployment (I have no idea how it would be setup), so having the cache set up ensures they can be fetched from the nix-on-droid Cachix cache.








# Configure Overlays for nix-on-droid

Ensure your overlays are properly set up to include nix-on-droid:
```
pkgsFor = system: import nixpkgs {
  inherit system;
  config = {
    allowUnfree = true;
    overlays = [
      (import ./nix/overlays)              # Your custom overlays
      # (final: prev: { nix-on-droid = nix-on-droid.packages.${system}; }) # not necessary, I use it in one of my flake apps
    ] ++ lib.optional (custom.isAndroid system) nix-on-droid.overlays.default; 
  };
}; # isAndroid is just checking against a list of [ "aarch64-linux" ], as I believe only that is really supported here

```


# Finalize and Deploy

With all configurations in place, deploy using:
```
deploy --targets ".#pioneer" -- --impure
```
Replace pioneer with the appropriate node name from your deploy.nodes configuration. (let me know if this can be done without --impure)
Deployment Log

Hope this helps someone. Final note, if you're cross compiling from x86_64-linux on your nixos desktop, add this to your desktops config and switch:
```
boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

```

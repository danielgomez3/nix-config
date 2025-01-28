let
    nixpkgs = import (builtins.getFlake "nixpkgs") {};
    isPublicSshKey = x: (builtins.match ".*\\.pub$") x != null;  # Left is evaluated first
in
{

nixpkgs = nixpkgs; # Expose nixpkgs as a top-level attribute


# Doing this:
# listOflistOfIfPublicKey ./.
# Returns unevaluated list of thunks in the repl, because this `listOlistOfIfPublicKey` is not a function! It's a list of thunks.
listOfIfPublicKey = map
    (file: isPublicSshKey (builtins.toString file))
    (nixpkgs.lib.filesystem.listFilesRecursive ./.);

}


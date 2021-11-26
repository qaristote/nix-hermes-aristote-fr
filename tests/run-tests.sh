#! /usr/bin/env nix-shell
#! nix-shell --packages curl

sudo nixos-container update hermes --config-file ./vm.nix || exit 2
sudo nixos-container start hermes || exit 2

IP=$(nixos-container show-ip hermes)
for PORT in 8080 8081 8082
do
    curl http://$IP:$PORT/ -i || exit 2
done

sudo nixos-container stop hermes

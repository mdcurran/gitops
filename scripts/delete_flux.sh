#!/usr/bin/env bash
export GHUSER="mdcurran"
export GHREPO="gitops"

fluxctl install \
    --git-user=${GHUSER} \
    --git-email=${GHUSER}@users.noreply.github.com \
    --git-url=git@github.com:${GHUSER}/${GHREPO} \
    --git-path=namespaces,workloads \
    --namespace=flux | kubectl delete -f -

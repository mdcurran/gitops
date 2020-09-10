#!/usr/bin/env bash
export GHUSER="mdcurran"
export GHREPO="gitops"

function check_prerequisites {
    # Check for kubectl installation.
    if ( kubectl version ) < /dev/null > /dev/null 2>&1; then
        echo "kubectl is installed!"
    else
        echo "Please install kubectl before continuing: https://kubernetes.io/docs/tasks/tools/install-kubectl/"
        exit 1
    fi

    # Check for fluxctl installation.
    if ( fluxctl version ) < /dev/null > /dev/null 2>&1; then
        echo "fluxctl is installed!"
    else
        echo "Please install fluxctl before continuing: https://docs.fluxcd.io/en/1.20.2/references/fluxctl/"
        exit 1
    fi
}

function check_kubernetes_configuration {
    if [ "`kubectl config current-context`" == "docker-desktop" ] || [ "`kubectl config current-context`" == "docker-for-desktop" ]; then
        echo "Local Kubernetes context selected."
    else
        echo "Please select your local Docker Kubernetes context."
        exit 1
    fi
}

function install_flux {
    # If the flux Namespace does not exist, then create it.
    echo "Creating the flux namespace."
    kubectl apply -f namespaces/flux.yaml

    # Install flux and link to the desired Git repository.
    fluxctl install \
        --git-user=${GHUSER} \
        --git-email=${GHUSER}@users.noreply.github.com \
        --git-url=git@github.com:${GHUSER}/${GHREPO} \
        --namespace=flux | kubectl apply -f -
}

function main {
    check_prerequisites
    check_kubernetes_configuration
    install_flux
}

main

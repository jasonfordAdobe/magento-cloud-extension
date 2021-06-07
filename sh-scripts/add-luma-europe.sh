# shellcheck shell=bash
: || source lib.sh # trick shellcheck into finding certain referenced vars

languageChoiceToggle () {
    local choice=$1
    if [[ ${opts[choice]} ]] # toggle
    then
        opts[choice]=
    else
        opts[choice]=✓
    fi
}

getComposerRequireString () {
    PS3='Please enter your choice: '
    while :
    do
        clear
        options=("Install All" "be-nl [${opts[2]}]" "be-fr [${opts[3]}]" "de-de [${opts[4]}]" "es-es [${opts[5]}]" "fr-fr [${opts[6]}]" "se-sv [${opts[7]}]" "Install Selected")

        select opt in "${options[@]}"
        do
            case $opt in
                "Install All")
                    opts=()
                    languageChoiceToggle 1
                    break 2
                    ;;
                "be-nl [${opts[2]}]")
                    languageChoiceToggle 2
                    break
                    ;;
                "be-fr [${opts[3]}]")
                    languageChoiceToggle 3
                    break
                    ;;
                "de-de [${opts[4]}]")
                    languageChoiceToggle 4
                    break
                    ;;
                "es-es [${opts[5]}]")
                    languageChoiceToggle 5
                    break
                    ;;
                "fr-fr [${opts[6]}]")
                    languageChoiceToggle 6
                    break
                    ;;
                "se-sv [${opts[7]}]")
                    languageChoiceToggle 7
                    break
                    ;;
                "Install Selected")
                    break 2
                    ;;
                *) printf '%s\n' 'invalid option';;
            esac
        done < /dev/tty
    done

    REQUIRE_STRING='composer require magentoese/module-data-install:dev-beta-b2c imi/magento2-store-switch-all-store-views:dev-dev-luma-europe jasfordadobe/commerceimprovements jasonfordadobe/pagebuilder-icon jasfordadobe/pagebuilder-anchor jasfordadobe/pagebuilder-animate jasfordadobe/quickcreatecli jasfordadobe/luma-europe-data-install:dev-master jasfordadobe/luma-europe-new-products-data-install:dev-master jasfordadobe/luma-europe-nl-nl-data-install:dev-master'

    for opt in "${!opts[@]}"
    do
        case $opt in
            1)
                REQUIRE_STRING="${REQUIRE_STRING} jasfordadobe/luma-europe-se-sv-data-install:dev-master jasfordadobe/luma-europe-fr-fr-data-install:dev-master jasfordadobe/luma-europe-es-es-data-install:dev-master jasfordadobe/luma-europe-de-de-data-install:dev-master jasfordadobe/luma-europe-be-nl-data-install:dev-master jasfordadobe/luma-europe-be-fr-data-install:dev-master"
                ;;
            2)
                REQUIRE_STRING="${REQUIRE_STRING} jasfordadobe/luma-europe-be-nl-data-install:dev-master"
                ;;
            3)
                REQUIRE_STRING="${REQUIRE_STRING} jasfordadobe/luma-europe-be-fr-data-install:dev-master"
                ;;
            4)
                REQUIRE_STRING="${REQUIRE_STRING} jasfordadobe/luma-europe-de-de-data-install:dev-master"
                ;;
            5)
                REQUIRE_STRING="${REQUIRE_STRING} jasfordadobe/luma-europe-es-es-data-install:dev-master"
                ;;
            6)
                REQUIRE_STRING="${REQUIRE_STRING} jasfordadobe/luma-europe-fr-fr-data-install:dev-master"
                ;;
            7)
                REQUIRE_STRING="${REQUIRE_STRING} jasfordadobe/luma-europe-se-sv-data-install:dev-master"
                ;;
            *)
                printf '%s\n' 'invalid option';;
        esac
    done

    REQUIRE_STRING="${REQUIRE_STRING} --ignore-platform-reqs"

    echo "$REQUIRE_STRING"
}

#msg "Adding Luma Europe vertical..."

## Configure your Luma Europe
#msg "Configure your Luma Europe"
composerRequireString=$( getComposerRequireString )

[[ "$(which composer)" ]] || error "Composer is not installed. You must install composer to continue. https://getcomposer.org/download/"

tmp_git_dir="$(mktemp -d)"
git clone --branch "$environment" "$project@git.demo.magento.cloud:$project.git" "$tmp_git_dir"
cd "$tmp_git_dir" || exit
git config user.email "chrome-extension@email.com"
git config user.name "chrome-extension"
export COMPOSER_PROCESS_TIMEOUT=600 COMPOSER_MEMORY_LIMIT=-1
## Composer add repos
msg "Adding repos"
composer config repositories.luma-europe-data-install git git@github.com:jasonfordAdobe/luma-europe-data-install.git
composer config repositories.luma-europe-new-products-data-install git git@github.com:jasonfordAdobe/luma-europe-new-products-data-install.git
composer config repositories.luma-europe-nl-nl-data-install git git@github.com:jasonfordAdobe/luma-europe-nl-nl-data-install.git
composer config repositories.luma-europe-se-sv-data-install git git@github.com:jasonfordAdobe/luma-europe-se-sv-data-install.git
composer config repositories.luma-europe-fr-fr-data-install git git@github.com:jasonfordAdobe/luma-europe-fr-fr-data-install.git
composer config repositories.luma-europe-es-es-data-install git git@github.com:jasonfordAdobe/luma-europe-es-es-data-install.git
composer config repositories.luma-europe-de-de-data-install git git@github.com:jasonfordAdobe/luma-europe-de-de-data-install.git
composer config repositories.luma-europe-be-nl-data-install git git@github.com:jasonfordAdobe/luma-europe-be-nl-data-install.git
composer config repositories.luma-europe-be-fr-data-install git git@github.com:jasonfordAdobe/luma-europe-be-fr-data-install.git
composer config repositories.store-switcher git git@github.com:jasonfordAdobe/magento2-store-switch-all-store-views.git

## Composer Remove
msg "Removing Venia to save storage space"
composer remove magentoese/theme-frontend-venia --ignore-platform-reqs

## Composer Require B2C Data Install
msg "Requiring data install module version"
## Composer Require Store Switcher (altered version of IMI)
msg "Requiring alternate store switcher"
## Compsoer Require Additional Modules
msg "Requiring custom modules for commerce"
composer require mageplaza/magento-2-swedish-language-pack:dev-master
## composer require magentoese/module-data-install:dev-beta-b2c imi/magento2-store-switch-all-store-views:dev-dev-luma-europe jasfordadobe/commerceimprovements jasonfordadobe/pagebuilder-icon jasfordadobe/pagebuilder-anchor jasfordadobe/pagebuilder-animate jasfordadobe/quickcreatecli jasfordadobe/luma-europe-data-install:dev-master jasfordadobe/luma-europe-new-products-data-install:dev-master jasfordadobe/luma-europe-nl-nl-data-install:dev-master jasfordadobe/luma-europe-se-sv-data-install:dev-master jasfordadobe/luma-europe-fr-fr-data-install:dev-master jasfordadobe/luma-europe-es-es-data-install:dev-master jasfordadobe/luma-europe-de-de-data-install:dev-master jasfordadobe/luma-europe-be-nl-data-install:dev-master jasfordadobe/luma-europe-be-fr-data-install:dev-master --ignore-platform-reqs
eval $composerRequireString

## Disable Modules
##$cmd_prefix "php $app_dir/bin/magento module:disable MagentoEse_SwitcherLogos"
msg "Removing the MagentoEse Switcher module"
perl -i -pe "s/MagentoEse_SwitcherLogos' => 1/MagentoEse_SwitcherLogos' => 0/g" app/etc/config.php

msg "Adding and committing the git repo"
git add composer.*
git add app/etc/config.php
git commit -m "Adding Luma Europe"
git push
rm -rf "$tmp_git_dir" # clean up

# curl -sS https://raw.githubusercontent.com/jasonfordAdobe/magento-cloud-extension/vertical-luma-europe/sh-scripts/{lib.sh,add-luma-europe.sh,reindex-on-schedule.sh,reindex.sh,cache-flush.sh,cache-warm.sh} | env ext_ver=0.0.31 tab_url=https://demo.magento.cloud/projects/pa2p6kzfphbvi/environments/test-2 bash

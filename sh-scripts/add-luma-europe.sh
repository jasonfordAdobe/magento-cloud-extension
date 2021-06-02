# shellcheck shell=bash
: || source lib.sh # trick shellcheck into finding certain referenced vars

msg "Adding Luma Europe vertical ..."

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
composer require magentoese/module-data-install:dev-beta-b2c imi/magento2-store-switch-all-store-views:dev-dev-luma-europe jasfordadobe/commerceimprovements jasonfordadobe/pagebuilder-icon jasfordadobe/pagebuilder-anchor jasfordadobe/pagebuilder-animate jasfordadobe/quickcreatecli jasfordadobe/luma-europe-data-install:dev-master jasfordadobe/luma-europe-new-products-data-install:dev-master jasfordadobe/luma-europe-nl-nl-data-install:dev-master jasfordadobe/luma-europe-se-sv-data-install:dev-master jasfordadobe/luma-europe-fr-fr-data-install:dev-master jasfordadobe/luma-europe-es-es-data-install:dev-master jasfordadobe/luma-europe-de-de-data-install:dev-master jasfordadobe/luma-europe-be-nl-data-install:dev-master jasfordadobe/luma-europe-be-fr-data-install:dev-master --ignore-platform-reqs

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

# curl -sS https://raw.githubusercontent.com/jasonfordAdobe/magento-cloud-extension/vertical-luma-europe/sh-scripts/{lib.sh,add-luma-europe.sh,cache-flush.sh} | env ext_ver=0.0.31 tab_url=https://demo.magento.cloud/projects/pa2p6kzfphbvi/environments/test-1 bash
# shellcheck shell=bash
: || source lib.sh # trick shellcheck into finding certain referenced vars

warning "Compilation and deployment may take a couple minutes."

$cmd_prefix "php $app_dir/bin/magento deploy:mode:set production"

printf "\nWatching logs ...\n"

#  $ssh_cmd "stdbuf -oL tail -f /var/log/php.access.log ${home_dir}/var/log/system.log ${home_dir}/var/log/exception.log | \
#    stdbuf -oL perl -pe 's!${home_dir}/var/log/system.log!${green}\$&${no_color}!; s!${home_dir}/var/log/exception.log!${red}\$&${no_color}!;'"

$ssh_cmd "stdbuf -oL tail -f /var/log/php.access.log ${home_dir}/var/log/system.log ${home_dir}/var/log/exception.log"
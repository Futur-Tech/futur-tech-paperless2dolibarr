#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_func"
source "$(dirname "$0")/ft-util/ft_util_inc_var"
source "$(dirname "$0")/ft-util/ft_util_usrmgmt"

app_name="futur-tech-paperless2dolibarr"

bin_dir="/usr/local/bin/${app_name}"
etc_conf="/usr/local/etc/${app_name}.conf"
required_pkg_arr=("rsync")

# Install needed packages
$S_DIR_PATH/ft-util/ft_util_pkg -u -i ${required_pkg_arr[@]} || exit 1

mkdir_if_missing $bin_dir

$S_DIR_PATH/ft-util/ft_util_file-deploy "$S_DIR_PATH/bin/" "${bin_dir}"
$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/ft-util/ft_util_log" "${bin_dir}/ft_util_log"
$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/ft-util/ft_util_inc_var" "${bin_dir}/ft_util_inc_var"

enforce_security exec "$bin_dir" adm

$S_DIR_PATH/ft-util/ft_util_conf-update -s "$S_DIR_PATH/etc/${app_name}.conf" -d "${etc_conf}"
enforce_security conf "$etc_conf" adm

[ ! -e "/var/log/${app_name}_sync.log" ] && run_cmd_log touch /var/log/${app_name}_sync.log
run_cmd_log chown root:adm /var/log/${app_name}_sync.log
run_cmd_log chmod 640 /var/log/${app_name}_sync.log

# Installing cron for running script
$S_DIR/ft-util/ft_util_file-deploy "$S_DIR_PATH/etc.cron.d/futur-tech-paperless2dolibarr" "/etc/cron.d/futur-tech-paperless2dolibarr" "NO-BACKUP"

exit

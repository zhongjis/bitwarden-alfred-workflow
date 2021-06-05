#!/bin/bash

_writeplist() {
/bin/cat <<EOF >"${plist_path}"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>$launchd_name</string>
	<key>ProgramArguments</key>
	<array>
		<string>/bin/bash</string>
		<string>--</string>
		<string>$wf_dir/${0##*/}</string>
	</array>
	<key>StartCalendarInterval</key>
	<dict>
		<key>Hour</key>
		<integer>$AUTO_HOUR</integer>
		<key>Minute</key>
		<integer>$AUTO_MIN</integer>
	</dict>
</dict>
</plist>
EOF
}

_install_service() {
	AUTO_HOUR=$(_get_var_from_plist "${infoplist}" variables.AUTO_HOUR)
	AUTO_MIN=$(_get_var_from_plist "${infoplist}" variables.AUTO_MIN)
	re='^[0-9]+$'
	if ! [[ $AUTO_HOUR =~ $re ]]; then
		echo "error: AUTO_HOUR must be a number" 1>&2
		return
	fi
	if ! [[ $AUTO_MIN =~ $re ]]; then
		echo "error: AUTO_MIN must be a number" 1>&2
		return
	fi
	if [ "$AUTO_HOUR" -lt 0 ] || [ "$AUTO_HOUR" -gt 23 ]; then
		echo "error: AUTO_HOUR must be between 0-23"
		return
	fi
	if [ "$AUTO_MIN" -lt 0 ] || [ "$AUTO_MIN" -gt 59 ]; then
		echo "error: AUTO_MIN must be between 0-59"
		return
	fi
	echo "installing LaunchAgent"
	/bin/launchctl remove ${launchd_name} 2>/dev/null
	_writeplist
	/bin/launchctl load "${plist_path}"
	/bin/launchctl start ${launchd_name}
	if [ $? -eq 0 ]; then
		echo "success"
	else
		echo "fail"
	fi
}

_remove_service() {
	echo "removing LaunchAgent"
	/bin/launchctl remove ${launchd_name} 2>/dev/null
	if [ $? -eq 0 ]; then
	  test -f "${plist_path}" && /bin/rm -f "${plist_path}"
		echo "success"
	else
		echo "fail"
	fi
}

_get_var_from_plist() {
	# 1=filename, 2=key
	[ -n "$2" ] || return 1
	[ -e "$1" ] || return 1
	/usr/bin/plutil -extract "$2" xml1 -o - -- "$1" |
	/usr/bin/sed -n "s/.*<string>\(.*\)<\/string>.*/\1/p"
}

prefs="$HOME/Library/Application Support/Alfred/prefs.json"
[ -e "${prefs}" ] || { echo "can't find Alfred prefs"; exit 1; }
wf_basedir=$(_get_var_from_plist "${prefs}" current)/workflows
[ -e "${wf_basedir}" ] || { echo "can't find Alfred workflow dir"; exit 1; }

alfred_app_bundleid=com.runningwithcrayons.Alfred
export alfred_workflow_bundleid=com.lisowski-development.alfred.bitwarden
export alfred_workflow_cache="$HOME/Library/Caches/${alfred_app_bundleid}/Workflow Data/${alfred_workflow_bundleid}"
export alfred_workflow_data="$HOME/Library/Application Support/Alfred/Workflow Data/${alfred_workflow_bundleid}"
launchd_name=${alfred_workflow_bundleid}_cacheupdate
plist_path="$HOME/Library/LaunchAgents/${0##*/}_agent.plist"

#wf_basedir=$(_get_var_from_plist "$HOME/Library/Preferences/com.runningwithcrayons.Alfred-Preferences.plist" syncfolder)
infoplist=$(/usr/bin/find "${wf_basedir}" -name info.plist -depth 2 -exec /usr/bin/grep -H "<string>${alfred_workflow_bundleid}</string>" {} \; | /usr/bin/awk -F: '{ print $1 }')
[ -e "${infoplist}" ] || { echo "can't find Bitwarden v2 workflow"; exit 1; }
wf_dir=${infoplist%/*}
alfred_workflow_version=$(_get_var_from_plist "${infoplist}" version)
[ -n "${alfred_workflow_version}" ] || { echo "can't determine workflow version"; exit 1; }
echo "found workflow v${alfred_workflow_version} at ${wf_dir}"
export alfred_workflow_version
bwpath=$(_get_var_from_plist "${infoplist}" variables.PATH)
[ -n "${bwpath}" ] || { echo "PATH variable not set in workflow"; exit 1; }
export PATH=${bwpath}
bwexec=$(_get_var_from_plist "${infoplist}" variables.BW_EXEC)
if ! hash "${bwexec}" 2>/dev/null; then
	echo "bw command not found, check PATH env variable"; exit 1;
fi
export BW_EXEC=${bwexec}
wf_bin="${wf_dir}/bitwarden-alfred-workflow"

case $1 in
	(-i|--install) _install_service; exit;;
	(-r|--remove) _remove_service; exit;;
esac

/usr/bin/xattr -d com.apple.quarantine "$wf_bin" 2>/dev/null
"$wf_bin" -sync -force
#"$wf_bin" -icons

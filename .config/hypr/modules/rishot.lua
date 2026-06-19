hl.bind("Print", hl.dsp.exec_cmd("flock -n -o /tmp/rishot.lock qs -c rishot"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("flock -n -o /tmp/rishot.lock env RISHOT_MODE=monitor qs -c rishot"))

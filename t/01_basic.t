BEGIN { $| = 1; print "1..5\n"; }

use Proc::FastSpawn;

print "ok 1\n";
my $pid = spawn $^X, ["perl", "-e", "exit 5"];
print $pid ? "" : "not ", "ok 2\n";
print +($pid == waitpid $pid, 0) ? "" : "not ", "ok 3\n";
print $? == 0x0500 ? "" : "not ", "ok 4\n";
print "ok 5\n";

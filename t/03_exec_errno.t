
use Test::More tests => 6;

use Proc::FastSpawn;

#ok 1;
#is Proc::FastSpawn::test_check_exec_errno(), 42, "test_check_exec_errno";

{
    note "a failing process";

    local ( $?, $! );

    my $pid = spawn "/bin/whatever", [ "/bin/whatever", "-e", "exit 5" ];
    if ($pid) {
        ok $pid, "pid $pid";
        waitpid( $pid, 0 );

        ok $?, q[$? is set];

        note '$?: ', $?;
        note '$!: ', $!;

        is Proc::FastSpawn::check_last_exec_errno(), 2, "check_exec_errno report 2";
    }
}

{
    local ( $?, $! );

    note "a working process";
    my $pid = spawn $^X, [ "perl", "-e", "print qq[# print from kid: abcd\n];" ];
    if ($pid) {
        ok $pid, "pid $pid";
        waitpid( $pid, 0 );

        is $?, 0, q[$? is not set];

        note '$?: ', $?;
        note '$!: ', $!;

        is Proc::FastSpawn::check_last_exec_errno(), 0, "check_exec_errno report no errors";
    }
}

__END__

SV*
test_check_exec_errno()
  CODE:
    int i;
    i = 42;

    /* RETVAL = newSViv( i ); */
    setup_last_exec_errno();
    set_last_exec_errno(42);

    RETVAL = newSViv( get_last_exec_errno() );

  OUTPUT:
    RETVAL

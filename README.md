# NAME

Cmd::Interpreter - Support for line-oriented command interpreters

# SYNOPSIS

    use Cmd::Interpreter;
    our @ISA = qw(Cmd::Interpreter);

# USAGE

- Write your class

        package Example::Hello;

        use strict;
        use warnings;

        use Cmd::Interpreter;

        our @ISA = qw(Cmd::Interpreter);

        sub help {
            my $self = shift;
            print "common help\n";
            return '';
        }

        sub do_hello {
            my $self = shift;
            print "Hello " . (shift || "World") . "!\n";
            return '';
        }

        sub help_hello {
            my $self = shift;
            print "help for hello\n";
            return '';
        }

        sub do_quit {
            my $self = shift;
            print "By\n";
            return "quit";
        }

        sub empty_line {
        }

        1;

- Use your class

        use strict;
        use warnings;

        use Example::Hello;

        my $ex = Example::Hello->new(prompt => 'example> ');
        $ex->run("Welcome to hello world app.");

# DESCRIPTION

Cmd::Interpreter provides a simple framework for writing line-oriented
command interpreters. These are often useful for test harnesses,
administrative tools, and prototypes that will later be wrapped in a
more sophisticated interface.

# AUTHOR

Oleg Kulikov <oakulikov@yandex.ru>

# THANKS TO

Authors of Python Lib/cmd.py

# LICENSE

Copyright (C) Oleg Kulikov.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

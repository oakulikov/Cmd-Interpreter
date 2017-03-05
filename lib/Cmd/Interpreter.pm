package Cmd::Interpreter;
use 5.008001;
use strict;
use warnings;

use Term::ReadLine;

our $VERSION = "0.01";

use constant IDENT_CHARS => join '', 'a'..'z', 'A'..'Z', '0' .. '9', '_';
use constant PROG_NAME => 'Simple command interpreter';
use constant PROMPT => 'cmd> ';


sub new {
    my $class = shift;
    my %args = @_;

    my $self = {
        prog_name => PROG_NAME,
        prompt => PROMPT,
        last_cmd => '',
        %args
    };

    return bless $self, $class;
}


sub run {
    my $self = shift;

    $self->pre_loop();
    $self->loop(@_);
    $self->post_loop();
}


sub loop {
    my $self = shift;
    my $intro = shift;

    print "$intro\n" if $intro;

    my $term = Term::ReadLine->new($self->{prog_name});
    my $stop = '';

    while (defined(my $line = $term->readline($self->{prompt}))) {

        $line = $self->pre_cmd($line);
        $stop = $self->do_cmd($line);
        $stop = $self->post_cmd($stop, $line);

        last if $stop;
    }
}


sub pre_loop {
}


sub post_loop {
}


sub pre_cmd {
    my $self = shift;

    return shift;
}


sub post_cmd {
    my $self = shift;

    return shift;
}


sub default_action {
}


sub empty_line {
    my $self = shift;

    return $self->do_cmd($self->{last_cmd}) if $self->{last_cmd};
    return '';
}


sub no_input {
    my $self = shift;

    print "\n";

    return "exit";
}


sub do_help {
    my $self = shift;
    my $topic = shift;

    if ($topic) {
        my $sub = "help_$topic";

        if ($self->check_sub($sub)) {
            return $self->$sub();
        }

        print "There is no help for '$topic'\n";
    } else {
        my $sub = "help";

        if ($self->check_sub($sub)) {
            return $self->$sub();
        }

        print "Please try: '?command' or 'help command'\n";
    }

    return '';
}


sub do_shell {
    my $self = shift;
    my $cmd = shift;

    if ($cmd) {
        print `$cmd`;
    } else {
        print "Please use: '!command [args]' or 'shell command [args]'\n";
    }

    return '';
}


sub do_cmd {
    my $self = shift;

    return $self->no_input() unless $_[0];

    my ($cmd, $args, $line) = $self->parse_line(shift);

    return $self->empty_line() unless $line;
    return $self->default_action() unless $cmd;

    my $sub = $self->check_sub("do_$cmd");

    return $self->default_action() unless $sub;

    $self->{last_cmd} = $line;

    return $self->$sub($args);
}


sub check_sub {
    my $self = shift;
    my $sub = shift;

    return $self->can($sub) ? $sub : '';
}


sub parse_line {
    my $self = shift;
    my $line = shift;

    chomp $line;

    return ('', '', $line) unless $line;

    if ($line =~ /\?(.*)/) {
        $line = "help $1";
    } elsif ($line =~ /!(.*)/) {
        $line = "shell $1";
    }

    return ($1, $2, $line) if $line =~ /^([@{[IDENT_CHARS]}]+)\s*(.*)\s*$/;
    return ('', '', $line);
}


1;
__END__

=encoding utf-8

=head1 NAME

Cmd::Interpreter - It's new $module

=head1 SYNOPSIS

    use Cmd::Interpreter;

=head1 DESCRIPTION

Cmd::Interpreter is ...

=head1 LICENSE

Copyright (C) Oleg Kulikov.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Oleg Kulikov E<lt>oakulikov@yandex.ruE<gt>

=cut


package App::perlmv::scriptlet::add_suffix;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

our $SCRIPTLET = {
    summary => 'Add suffix to filenames',
    args => {
        suffix => {
            summary => 'The suffix string',
            schema => 'str*',
            req => 1,
        },
        before_ext => {
            summary => 'Put suffix before filename extension',
            schema => 'bool*',
        },
        avoid_duplicate_suffix => {
            summary => 'Avoid adding suffix when filename already has that suffix',
            schema => 'bool*',
        },
    },
    code => sub {
        package
            App::perlmv::code;

        use vars qw($ARGS);

        $ARGS && defined $ARGS->{suffix}
            or die "Please specify 'suffix' argument (e.g. '-a suffix=-new')";

        my ($name, $ext);

        if ($ARGS->{before_ext} && /\A(.+)((?:\.\w+)+)\z/) {
            ($name, $ext) = ($1, $2);
            #say "ext=<$ext>";
        } else {
            $name = $_;
            $ext = "";
        }

        #say "D:rindex=", rindex($name, $ARGS->{suffix});
        #say "D:length(suffix)=", length($ARGS->{suffix});
        #say "D:length(name)=", length($name);

        if ($ARGS->{avoid_duplicate_suffix} &&
                rindex($name, $ARGS->{suffix})+length($ARGS->{suffix}) == length($name)) {
            #say "D:1";
            return $_;
        }
        "$name$ARGS->{suffix}$ext";
    },
};

1;

# ABSTRACT:

=head1 SYNOPSIS

With files:

 foo.txt
 bar-new.txt
 baz.txt-new

This command:

 % perlmv add-suffix -a suffix=-new *

will rename the files as follow:

 foo.txt -> foo.txt-new
 bar-new.txt -> bar-new.txt-new
 baz.txt-new baz.txt-new-new

This command:

 % perlmv add-suffix -a suffix=-new- -a before_ext=1 *

will rename the files as follow:

 foo.txt -> foo-new.txt
 bar-new.txt -> bar-new-new.txt
 baz.txt-new baz-new.txt-new

This command:

 % perlmv add-suffix -a suffix=-new- -before_ext=1 -a avoid_duplicate_suffix=1 *

will rename the files as follow:

 foo.txt -> foo-new.txt
 baz.txt-new baz-new.txt-new


=head1 SEE ALSO

L<App::perlmv::scriptlet::add_prefix>

The C<remove-common-suffix> scriptlet

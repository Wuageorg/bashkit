# Definitions
These definitions are used throughout the remainder of this manual.

**POSIX** \
A family of open system standards based on Unix. Bash and Bashkit are primarily concerned with the Shell\
and Utilities portion of the POSIX 1003.1 standard.

**blank** \
A space or a tab character.

**builtin** \
A command that is implemented internally by the shell itself, rather than by an executable program \
somewhere in the file system.

**control operator** \
A token that performs a control function. It is a newline or one of the following: \
‘||’, ‘&&’, ‘&’, ‘;’, ‘;;’, ‘;&’, ‘;;&’, ‘|’, ‘|&’, ‘(’, or ‘)’.

**exit status or error code or errcode** \
The value returned by a command to its caller. The value is restricted to eight bits, \
so the maximum value is 255.

**field** \
A unit of text that is the result of one of the shell expansions. After expansion, when \
executing a command, the resulting fields are used as the command name and arguments.

**filename** \
A string of characters used to identify a file.

**job** \
A set of processes comprising a pipeline, and any processes descended from it, that are \
all in the same process group.

**job control** \
A mechanism by which users can selectively stop (suspend) and restart (resume) execution \
of processes.

**metacharacter** \
A character that, when unquoted, separates words. A metacharacter is a space, tab, newline, \
or one of the following characters: ‘|’, ‘&’, ‘;’, ‘(’, ‘)’, ‘<’, or ‘>’.

**name** \
A word consisting solely of letters, numbers, and underscores, and beginning with a letter \
or underscore. Names are used as shell variable and function names. Also referred to as an \
identifier.

**operator** \
A control operator or a redirection operator. See Redirections, for a list of redirection \
operators. Operators contain at least one unquoted metacharacter.

**process group** \
A collection of related processes each having the same process group ID.

**process group ID** \
A unique identifier that represents a process group during its lifetime.

**reserved word** \
A word that has a special meaning to the shell. Most reserved words introduce shell flow \
control constructs, such as for and while.

**return status** \
A synonym for exit status.

**signal** \
A mechanism by which a process may be notified by the kernel of an event occurring in \
the system.

**special builtin** \
A shell builtin command that has been classified as special by the POSIX standard.

**token** \
A sequence of characters considered a single unit by the shell. It is either a word or \
an operator.

**word** \
A sequence of characters treated as a unit by the shell. Words may not include unquoted \
metacharacters.

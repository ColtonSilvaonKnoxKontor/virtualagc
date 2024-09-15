#!/usr/bin/env python

# CAVEAT UTILITOR
#
# This file was automatically generated by TatSu.
#
#    https://pypi.python.org/pypi/tatsu/
#
# Any changes you make to it will be overwritten the next time
# the file is generated.

from __future__ import annotations

import sys

from tatsu.buffering import Buffer
from tatsu.parsing import Parser
from tatsu.parsing import tatsumasu
from tatsu.parsing import leftrec, nomemo, isname # noqa
from tatsu.infos import ParserConfig
from tatsu.util import re, generic_main  # noqa


KEYWORDS = {}  # type: ignore


class riAllBuffer(Buffer):
    def __init__(self, text, /, config: ParserConfig = None, **settings):
        config = ParserConfig.new(
            config,
            owner=self,
            whitespace=None,
            nameguard=None,
            comments_re=None,
            eol_comments_re=None,
            ignorecase=False,
            namechars='',
            parseinfo=False,
        )
        config = config.replace(**settings)
        super().__init__(text, config=config)


class riAllParser(Parser):
    def __init__(self, /, config: ParserConfig = None, **settings):
        config = ParserConfig.new(
            config,
            owner=self,
            whitespace=None,
            nameguard=None,
            comments_re=None,
            eol_comments_re=None,
            ignorecase=False,
            namechars='',
            parseinfo=False,
            keywords=KEYWORDS,
            start='operand',
        )
        config = config.replace(**settings)
        super().__init__(config=config)

    @tatsumasu()
    def _operand_(self):  # noqa
        self._register_()
        self._token(',')
        self._immediate_()
        self._check_eof()

    @tatsumasu()
    def _immediate_(self):  # noqa
        with self._choice():
            with self._option():
                self._identifier_()
            with self._option():
                self._variable_()
            with self._option():
                self._constant_()
            self._error(
                'expecting one of: '
                '"B\'" "L\'" "X\'" &[@#$A-Z][@#$A-Z0-9]*'
                '<constant> <identifier> <variable>'
                '[0-9]+ [@#$A-Z][@#$A-Z0-9]*'
            )

    @tatsumasu()
    def _register_(self):  # noqa
        with self._choice():
            with self._option():
                self._identifier_()
            with self._option():
                self._variable_()
            with self._option():
                self._constant_()
            self._error(
                'expecting one of: '
                '"B\'" "L\'" "X\'" &[@#$A-Z][@#$A-Z0-9]*'
                '<constant> <identifier> <variable>'
                '[0-9]+ [@#$A-Z][@#$A-Z0-9]*'
            )

    @tatsumasu()
    def _identifier_(self):  # noqa
        self._pattern('[@#$A-Z][@#$A-Z0-9]*')

    @tatsumasu()
    def _variable_(self):  # noqa
        self._pattern('&[@#$A-Z][@#$A-Z0-9]*')

    @tatsumasu()
    def _constant_(self):  # noqa
        with self._choice():
            with self._option():
                self._pattern('[0-9]+')
            with self._option():
                self._token("X'")
                self._pattern('[0-9A-F]+')
                self._token("'")
            with self._option():
                self._token("B'")
                self._pattern('[0-1]+')
                self._token("'")
            with self._option():
                self._token("L'")
                self._identifier_()
            self._error(
                'expecting one of: '
                '"B\'" "L\'" "X\'" [0-9]+'
            )


class riAllSemantics:
    def operand(self, ast):  # noqa
        return ast

    def immediate(self, ast):  # noqa
        return ast

    def register(self, ast):  # noqa
        return ast

    def identifier(self, ast):  # noqa
        return ast

    def variable(self, ast):  # noqa
        return ast

    def constant(self, ast):  # noqa
        return ast


def main(filename, **kwargs):
    if not filename or filename == '-':
        text = sys.stdin.read()
    else:
        with open(filename) as f:
            text = f.read()
    parser = riAllParser()
    return parser.parse(
        text,
        filename=filename,
        **kwargs
    )


if __name__ == '__main__':
    import json
    from tatsu.util import asjson

    ast = generic_main(main, riAllParser, name='riAll')
    data = asjson(ast)
    print(json.dumps(data, indent=2))

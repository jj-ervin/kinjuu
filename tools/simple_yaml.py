#!/usr/bin/env python3
"""Small YAML reader for the limited governance schema used in this repo."""
from __future__ import annotations

import re
from pathlib import Path


def _strip_inline_comment(text: str) -> str:
    in_single = False
    in_double = False
    result = []
    for index, char in enumerate(text):
        if char == "'" and not in_double:
            in_single = not in_single
        elif char == '"' and not in_single:
            in_double = not in_double
        elif char == '#' and not in_single and not in_double:
            if index == 0 or text[index - 1].isspace():
                break
        result.append(char)
    return ''.join(result).rstrip()


def _parse_scalar(value: str):
    value = value.strip()
    if not value:
        return ''
    if value in {'{}', '{ }'}:
        return {}
    if value in {'[]', '[ ]'}:
        return []
    if (value.startswith('"') and value.endswith('"')) or (value.startswith("'") and value.endswith("'")):
        return value[1:-1]
    lowered = value.lower()
    if lowered == 'true':
        return True
    if lowered == 'false':
        return False
    if lowered in {'null', '~'}:
        return None
    if re.fullmatch(r'-?\d+', value):
        return int(value)
    if re.fullmatch(r'-?(?:\d+\.\d*|\.\d+)', value):
        return float(value)
    return value


def _looks_like_mapping(text: str) -> bool:
    if ':' not in text:
        return False
    key, _ = text.split(':', 1)
    return bool(key.strip())


def parse_yaml(path: Path):
    if not path.exists():
        return {}

    entries = []
    for raw in path.read_text(encoding='utf-8').splitlines():
        if not raw.strip() or raw.lstrip().startswith('#'):
            continue
        cleaned = _strip_inline_comment(raw)
        if not cleaned.strip():
            continue
        indent = len(cleaned) - len(cleaned.lstrip(' '))
        entries.append((indent, cleaned.strip()))

    if not entries:
        return {}

    def parse_dict_entries(index: int, indent: int):
        result = {}
        while index < len(entries):
            current_indent, text = entries[index]
            if current_indent < indent or current_indent != indent or text.startswith('- '):
                break
            key, rest = text.split(':', 1)
            key = key.strip()
            rest = rest.strip()
            index += 1
            if rest == '':
                if index < len(entries) and entries[index][0] > current_indent:
                    index, value = parse_block(index, entries[index][0])
                else:
                    value = {}
            else:
                value = _parse_scalar(rest)
            result[key] = value
        return index, result

    def parse_list(index: int, indent: int):
        result = []
        while index < len(entries):
            current_indent, text = entries[index]
            if current_indent < indent or current_indent != indent or not text.startswith('- '):
                break
            item_text = text[2:].strip()
            index += 1
            if item_text == '':
                if index < len(entries) and entries[index][0] > current_indent:
                    index, value = parse_block(index, entries[index][0])
                else:
                    value = None
                result.append(value)
                continue
            if _looks_like_mapping(item_text):
                key, rest = item_text.split(':', 1)
                key = key.strip()
                rest = rest.strip()
                item = {}
                if rest == '':
                    if index < len(entries) and entries[index][0] > current_indent:
                        index, value = parse_block(index, entries[index][0])
                    else:
                        value = {}
                else:
                    value = _parse_scalar(rest)
                item[key] = value
                index, extra = parse_dict_entries(index, current_indent + 2)
                item.update(extra)
                result.append(item)
                continue
            result.append(_parse_scalar(item_text))
        return index, result

    def parse_block(index: int, indent: int):
        _, text = entries[index]
        if text.startswith('- '):
            return parse_list(index, indent)
        return parse_dict_entries(index, indent)

    _, parsed = parse_block(0, entries[0][0])
    return parsed

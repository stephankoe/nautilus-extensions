#!/usr/bin/env python3
from argparse import ArgumentParser
import json

import yaml


def convert_yaml_to_json(yaml_path: str) -> str:
    with open(yaml_path, 'r') as fh:
        data = yaml.safe_load(fh)

    return json.dumps(data)


def main():
    parser = ArgumentParser(description="Convert YAML to JSON")
    parser.add_argument("yaml_file",
                        type=str,
                        help="Path to YAML file")
    args = parser.parse_args()

    json_data = convert_yaml_to_json(args.yaml_file)
    print(json_data)


if __name__ == '__main__':
    main()

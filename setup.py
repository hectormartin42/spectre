from setuptools import setup, find_packages

setup(
    name="spectre-spc",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        "click>=8.0",
    ],
    entry_points={
        "console_scripts": [
            "spc=spc.main:cli",
        ],
    },
    python_requires=">=3.10",
)

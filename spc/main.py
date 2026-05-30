import click
from spc.utils.banner import print_banner
from spc.modules.scan import run_scan
from spc.modules.workspace import launch_workspace, list_workspaces
from spc.modules.note import add_note, list_notes
from spc.modules.report import generate_report
from spc.modules.install import install_tool, install_all, list_tools


@click.group()
@click.version_option("0.1.0", prog_name="spc")
def cli():
    """Spectre — Cybersecurity & Pentesting OS toolkit"""
    pass


@cli.command()
def banner():
    """Print Spectre banner"""
    print_banner()


# ── scan ──────────────────────────────────────────────────────────────────────

@cli.command()
@click.option("--target", "-t", required=True, help="Target IP, range or hostname")
@click.option("--profile", "-p", default="normal",
              type=click.Choice(["stealth", "normal", "aggressive", "quick"]),
              show_default=True, help="Scan profile")
@click.option("--output", "-o", default=None, help="Output file prefix")
@click.option("--ports", default=None, help="Port range, e.g. 1-1000 or 80,443")
def scan(target, profile, output, ports):
    """Run a network scan against a target"""
    run_scan(target, profile, output, ports)


# ── workspace ─────────────────────────────────────────────────────────────────

@cli.command()
@click.argument("name", required=False)
def workspace(name):
    """Launch a preconfigured hacking workspace (web, network, red-team, osint, forensics)"""
    if name:
        launch_workspace(name)
    else:
        list_workspaces()


# ── note ──────────────────────────────────────────────────────────────────────

@cli.group()
def note():
    """Manage engagement notes"""
    pass


@note.command("add")
@click.argument("text")
@click.option("--tag", "-t", default=None, help="Tag, e.g. sqli, rce, cred")
@click.option("--engagement", "-e", default=None, help="Engagement name")
@click.option("--file", "-f", default=None, help="Attach a file path")
def note_add(text, tag, engagement, file):
    """Add a note to the current engagement"""
    add_note(text, tag, engagement, file)


@note.command("list")
@click.option("--engagement", "-e", default=None, help="Engagement name")
def note_list(engagement):
    """List notes for an engagement"""
    list_notes(engagement)


# ── report ────────────────────────────────────────────────────────────────────

@cli.command()
@click.option("--engagement", "-e", required=True, help="Engagement name")
@click.option("--format", "-f", "fmt", default="md",
              type=click.Choice(["md", "txt"]), show_default=True)
@click.option("--output", "-o", default=None, help="Output file name (no extension)")
def report(engagement, fmt, output):
    """Generate a report from engagement notes"""
    generate_report(engagement, fmt, output)


# ── install ───────────────────────────────────────────────────

@cli.command("install")
@click.argument("tool", required=False)
@click.option("--all", "all_tools", is_flag=True, help="Install all extra tools")
@click.option("--list", "show_list", is_flag=True, help="List available tools")
def install(tool, all_tools, show_list):
    """Install extra tools (AUR/pip) not included in the base ISO"""
    if show_list or (not tool and not all_tools):
        list_tools()
    elif all_tools:
        install_all()
    else:
        install_tool(tool)


if __name__ == "__main__":
    cli()

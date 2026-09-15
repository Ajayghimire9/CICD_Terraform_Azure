from pathlib import Path

import hcl2


def test_configuration_parses_and_has_no_tracked_state():
    for path in Path(".").glob("*.tf"):
        with path.open() as handle:
            assert isinstance(hcl2.load(handle), dict)
    assert not list(Path(".").glob("*.tfstate*"))
    assert "primary_access_key" not in Path("storage_account.tf").read_text()

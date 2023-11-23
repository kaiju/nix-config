ITEM_ID="42168592-2ad0-409d-9d54-ac1f014a3d19"
ATTACHMENT_ID="x2ro861lwganan3ktfrvxx3kg7qoi4ux"

bw login --check --quiet
if [[ $? == 1 ]]; then 
  BW_SESSION=$(bw login josh@mast.zone --raw)
else
  BW_SESSION=$(bw unlock --raw)
fi

mkdir -p ~/.ssh
chmod 0700 ~/.ssh

bw get attachment "$ATTACHMENT_ID" --itemid "$ITEM_ID" --output ~/.ssh/josh@mast.zone.key

chmod 0600 ~/.ssh/josh@mast.zone.key


.PHONY startup
startup:
	docker run --rm -it -v $(pwd)/code:/root/code -w /root/code -v $(pwd)/.ssh:/root/.ssh -v $(pwd)/secrets/gcloud:/root/.config/gcloud -p8080:8080 workstation -c "gcloud container clusters get-credentials production --zone europe-west1-c --project karrlein && tmux new-session -AD -s home"

.PHONY deamon
deamon:
	docker run --rm -it -d -v $(pwd)/code:/root/code -w /root/code -v $(pwd)/.ssh:/root/.ssh -v $(pwd)/secrets/gcloud:/root/.config/gcloud -p8080:8080 workstation -c "gcloud container clusters get-credentials production --zone europe-west1-c --project karrlein && tmux new-session -AD -s home"

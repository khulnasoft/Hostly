<?php

namespace App\Actions\Server;

use App\Jobs\PullHelperImageJob;
use App\Models\Server;
use Illuminate\Support\Sleep;
use Lorisleiva\Actions\Concerns\AsAction;

class UpdateHostly
{
    use AsAction;

    public ?Server $server = null;

    public ?string $latestVersion = null;

    public ?string $currentVersion = null;

    public function handle($manual_update = false)
    {
        if (isDev()) {
            Sleep::for(10)->seconds();

            return;
        }
        $settings = instanceSettings();
        $this->server = Server::find(0);
        if (! $this->server) {
            return;
        }
        CleanupDocker::dispatch($this->server);
        $this->latestVersion = get_latest_version_of_hostly();
        $this->currentVersion = config('constants.hostly.version');
        if (! $manual_update) {
            if (! $settings->is_auto_update_enabled) {
                return;
            }
            if ($this->latestVersion === $this->currentVersion) {
                return;
            }
            if (version_compare($this->latestVersion, $this->currentVersion, '<')) {
                return;
            }
        }
        $this->update();
        $settings->new_version_available = false;
        $settings->save();
    }

    private function update()
    {
        PullHelperImageJob::dispatch($this->server);

        instant_remote_process(["docker pull -q ghcr.io/khulnasoft/hostly:{$this->latestVersion}"], $this->server, false);

        remote_process([
            'curl -fsSL https://cdn.coollabs.io/hostly/upgrade.sh -o /data/hostly/source/upgrade.sh',
            "bash /data/hostly/source/upgrade.sh $this->latestVersion",
        ], $this->server);
    }
}

<?php

namespace Skynet\WebApp\Installers\Resources;

use Skynet\System\SkynetApp;

class WpResource {
	private $appcontext;
	private $options;

	public function __construct(SkynetApp $appcontext, $data, $destination, $options, $appinfo) {
		$this->appcontext = $appcontext;
		$this->appcontext->runWp(
			[
				"core",
				"download",
				"--locale=" . $options["language"],
				"--version=" . $appinfo["version"],
				"--path=" . $destination,
			],
			$status,
		);

		if ($status->code !== 0) {
			throw new \Exception("Error fetching WP resource: " . $status->text);
		}
	}
}

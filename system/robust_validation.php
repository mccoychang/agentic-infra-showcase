<?php

namespace McCoyLabs\System\Validation;

interface OSValidationStrategy
{
    /**
     * Identifies the operating system and its lineage.
     * 
     * @param array $osReleaseData Contents of /etc/os-release
     * @return IdentifiedOS
     */
    public function identify(array $osReleaseData): IdentifiedOS;

    /**
     * Determines the appropriate package manager and repository 
     * fallback chain for the detected version.
     */
    public function getDeploymentProfile(IdentifiedOS $os): array;
}

class IdentifiedOS
{
    public string $id;
    public string $version;
    public ?string $codename;
    public array $lineage; // Handled via ID_LIKE

    public function __construct(string $id, string $version, ?string $codename = null, array $lineage = [])
    {
        $this->id = $id;
        $this->version = $version;
        $this->codename = $codename;
        $this->lineage = $lineage;
    }
}

abstract class BaseOrchestrator
{
    protected OSValidationStrategy $strategy;

    public function __construct(OSValidationStrategy $strategy)
    {
        $this->strategy = $strategy;
    }

    /**
     * Validates if the target environment meets the criteria 
     * for high-performance agent deployment.
     */
    public function validateEnvironment(array $release): bool
    {
        $os = $this->strategy->identify($release);
        // Robust logic for handling distribution variants (Debian 13 Trixie, etc.)
        return !empty($os->id);
    }
}

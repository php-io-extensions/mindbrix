<?php

declare(strict_types=1);

if (! extension_loaded('mindbrix')) {
    throw new RuntimeException('The mindbrix extension is not loaded; run ./install-macos.sh');
}

function identity(): CGAffineTransform
{
    return new CGAffineTransform(1, 0, 0, 1, 0, 0);
}

/** CGRectNull: Rasterizer reads a null, empty or infinite clip as no clip. */
function noClip(): NSRect
{
    return new NSRect(INF, INF, 0, 0);
}

function red(): RAPaint
{
    return RAPaint::initWithRedGreenBlueAlpha(1, 0, 0, 1);
}

function rectArray(NSRect $r): array
{
    return [$r->x, $r->y, $r->width, $r->height];
}

/** A scene holding one fill of $path, so its geometry is validated (Rasterizer computes bounds then). */
function sceneWithFill(RAPath $path): RAScene
{
    $scene = RAScene::init();
    $scene->addFillCtmColorEvenOddClipClipPathBlendMode($path, identity(), red(), false, noClip(), null, RABlendMode::NORMAL);

    return $scene;
}

/** A file in the temporary directory holding $contents, removed at shutdown. */
function tempFile(string $suffix, string $contents): string
{
    $path = sys_get_temp_dir().'/mindbrix-'.getmypid().'-'.bin2hex(random_bytes(4)).$suffix;
    file_put_contents($path, $contents);
    register_shutdown_function(static fn () => @unlink($path));

    return $path;
}

/** A PDF of $pages pages, each 200x100 points with one filled rect, xref offsets computed. */
function pdfFile(int $pages): string
{
    $objects = [];
    $kids = [];
    for ($i = 0; $i < $pages; $i++) {
        $kids[] = (3 + 2 * $i).' 0 R';
    }
    $objects[1] = '<< /Type /Catalog /Pages 2 0 R >>';
    $objects[2] = '<< /Type /Pages /Kids ['.implode(' ', $kids).'] /Count '.$pages.' >>';
    for ($i = 0; $i < $pages; $i++) {
        $content = "1 0 0 rg 10 10 50 30 re f\n";
        $objects[3 + 2 * $i] = '<< /Type /Page /Parent 2 0 R /MediaBox [0 0 200 100] /Contents '.(4 + 2 * $i).' 0 R >>';
        $objects[4 + 2 * $i] = '<< /Length '.strlen($content)." >>\nstream\n".$content."endstream";
    }

    $pdf = "%PDF-1.4\n";
    $offsets = [];
    foreach ($objects as $n => $body) {
        $offsets[$n] = strlen($pdf);
        $pdf .= "$n 0 obj\n$body\nendobj\n";
    }
    $xref = strlen($pdf);
    $pdf .= 'xref'."\n0 ".(count($objects) + 1)."\n0000000000 65535 f \n";
    foreach ($offsets as $offset) {
        $pdf .= sprintf("%010d 00000 n \n", $offset);
    }
    $pdf .= 'trailer'."\n<< /Size ".(count($objects) + 1)." /Root 1 0 R >>\nstartxref\n$xref\n%%EOF\n";

    return tempFile('.pdf', $pdf);
}

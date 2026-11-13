<?php

/** @generate-class-entries */

/**
 * An NSView drawing an RASceneList with Metal (or Core Graphics when useCG is true) each display
 * frame while it is in a window. Make one with NSView's initWithFrame(). Its list delegate is held
 * weakly: keep the ObjCDelegate('RASceneListDelegate') alive.
 *
 * @not-serializable
 */
class RasterizerView extends NSView
{
    public function listDelegate(): ?NSObject {}

    public function setListDelegate(?NSObject $listDelegate): void {}

    public function useCG(): bool {}

    public function setUseCG(bool $useCG): void {}
}

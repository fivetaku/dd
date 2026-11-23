# dd — Codex 실행 메모

Codex에서도 같은 SKILL.md를 쓴다. 차이는 아래뿐이다.

- 경로: `${CLAUDE_PLUGIN_ROOT}`는 이 플러그인 루트(SKILL.md에서 두 단계 위 폴더)로 바꿔 읽는다. 캡처 스크립트는 `<루트>/skills/dd/scripts/dd_clipboard.py --json`.
- Step 0(첫 실행 설정): `setup/setup.sh`가 Codex에서는 아무것도 출력하지 않는다. 출력이 비면 조용히 넘어간다.
- 질문: 이 스킬은 선택지 질문을 하지 않는다. Step 4 확인은 `AskUserQuestion` 없이 채팅 일반 질문으로 한다(Codex도 동일). `codex exec`처럼 답할 사람이 없으면 묻지 않고 요청에 맞는 해석으로 진행하며, 가정 한 줄을 남긴다.
- Step 5의 서브에이전트(`Agent`): Codex에서는 `spawn_agent`가 있으면 쓰고, 없으면 메인 세션에서 순차로 처리한다. 모델 id를 지정하지 않는다(런타임이 고른다). 진단 지침 문구는 그대로 프롬프트에 넣는다.
- Step 7(이미지): 옛 Codex 포트도 별도 방법이 없고 "저장된 `image.png`를 본다"만 적혀 있었다. 세션에 이미지 열기 도구(`view_image` 등)가 있으면 `primary.path`로 열고, 없으면 경로·크기만 알리고 이미지를 직접 보지 못했다고 밝힌다. 이미지 내용을 추측하지 않는다.
- 클립보드 내용은 개인 데이터다. 매니페스트 `preview`(비밀값 가림 적용)만 채팅에 보이고 원문 전체를 되풀이하지 않는다.
